require 'spec_helper'

describe OvernightableJoiner do
  shared_examples :joining_overnightables_together do |model|
    table = model.table_name
    before :each do
      records.each do |fix|
        model.connection.insert_fixture fix, table
      end
    end
    let(:first) { model.order(:id).first }
    let(:last)  { model.order(:id).last }

    let(:result) { model.first } # must be called after #run!

    it "combines first and next day to one #{model} spanning all the time" do
      model.should have(2).records
      first.should_not eq(last)
      expect { subject.run! }.to change { model.count }.from(2).to(1)

      result.start_hour.should == starts_at.hour
      result.start_minute.should == starts_at.min
      result.end_hour.should == ends_at.hour
      result.end_minute.should == ends_at.min
      result.ends_at.should > result.starts_at
    end

    it 'keeps comments from first' do
      c1 = Comment.build_from(first, someone, body: 'Hello')
      c2 = Comment.build_from(first, someone, body: 'Anyone there?', parent: c1)
      [c1,c2].each(&:save!)

      first.comments.should have(2).records
      expect { subject.run! }.not_to change { Comment.count }.from(2)

      result.comments.should include(c1)
      result.comments.should include(c2)
    end if model.reflect_on_association(:comments)

    it 'keeps employee from first' do
      expect { subject.run! }.not_to change { Employee.count }.from(1)
      result.employee.should eq(someone)
    end if model.reflect_on_association(:employee)

    it 'keeps team from first' do
      subject.run!
      result.team.should eq(team)
    end

    it 'keeps plan' do
      subject.run!
      result.plan.should eq(plan)
    end if model.reflect_on_association(:plan)

    it "destroys column #{table}.next_day_id later (CREATE MIGRATION)"

  end

  it_behaves_like :joining_overnightables_together, Scheduling do
    # can ignore timezones here because rails converts them to/back automatically
    let(:starts_at) { Time.zone.parse('2014-09-24 16:00') }
    let(:ends_at)   { Time.zone.parse('2014-09-25 08:00') }
    let(:records) {[
        { plan_id: plan.id,
          starts_at: ends_at.beginning_of_day, # dropped
          ends_at: ends_at,
          id: 25 },
        { plan_id: plan.id,
          starts_at: starts_at,
          ends_at: starts_at.end_of_day, # dropped
          employee_id: someone.id,
          team_id: team.id,
          id: 24,
          next_day_id: 25 },
    ]}
  end
  it_behaves_like :joining_overnightables_together, Shift do
    # dates in db are always utc
    let(:starts_at) { Time.zone.parse('2014-09-24 16:00Z').utc }
    let(:ends_at)   { Time.zone.parse('2014-09-25 08:00Z').utc }
    let(:records) {[
        { starts_at: ends_at.beginning_of_day, # dropped
          ends_at: ends_at,
          id: 25 },
        { starts_at: starts_at,
          ends_at: starts_at.end_of_day, # dropped
          team_id: team.id,
          id: 24,
          next_day_id: 25 },
    ]}
  end

  let(:plan) { create :plan }
  let(:team) { create :team }
  let(:someone) { create :employee }
end
