require 'spec_helper'

shared_examples "a new created overnight shift" do
  it "has a next day" do
    overnight_shift

    overnight_shift.next_day.should_not be_nil
  end
  it "creates two shifts" do
    lambda {
      overnight_shift
    }.should change(Shift, :count).from(0).to(2)
  end

  it "splits the the hour ranges of the shifts at midnight" do
    overnight_shift

    nightshift.start_hour.should   == 22
    nightshift.start_minute.should == 15
    nightshift.end_hour.should     == 24
    nightshift.end_minute.should   == 0

    morning_shift.start_hour.should   ==  0
    morning_shift.start_minute.should ==  0
    morning_shift.end_hour.should     ==  6
    morning_shift.end_minute.should   == 45
  end

  it "delegates the demands of the next day to the previous day" do
    lambda {
      overnight_shift
    }.should change(Demand, :count).from(0).to(2)

    morning_shift.demands.should == nightshift.demands
  end

  it "increments the day for the second shift" do
    overnight_shift

    morning_shift.day.should == 1
  end

  it "copies the teams to the morning shift" do
    overnight_shift

    morning_shift.team.should eql(kitchen)
  end

  it "copies the plan template" do
    overnight_shift

    morning_shift.plan_template.should eql(plan_template)
  end
end

describe Shift do
  it "must have a plan template" do
    build(:shift, plan_template: nil).should_not be_valid
  end
  it "must have a team" do
    build(:shift, team: nil).should_not be_valid
  end
  it "must have a day" do
    build(:shift, day: nil).should_not be_valid
  end
  it "must have a start_at different from ends_at" do
    time = Time.zone.parse('08:00')
    build(:shift, starts_at: time, ends_at: time).should_not be_valid
  end

  describe "overnight shifts" do
    let(:plan_template) { create(:plan_template) }
    let(:cook)          { create(:qualification, name: "Cook") }
    let(:dishwasher)    { create(:qualification, name: "Dishwasher") }
    let(:kitchen)       { create(:team, name: "Kitchen") }
    let(:demands_attributes) do
      [
        { quantity: 2, qualification_id: cook.id },
        { quantity: 4, qualification_id: dishwasher.id }
      ]
    end
    let(:overnight_shift) do
      create(:shift, start_hour: 22, start_minute: 15, end_hour: 6, end_minute: 45, day: 0,
        plan_template: plan_template,
        team: kitchen,
        demands_attributes: demands_attributes
      )
    end
    let(:nightshift)    { Shift.find_by_day(0) }
    let(:morning_shift) { Shift.find_by_day(1) }

    describe "creating overnight shifts" do
      it_behaves_like "a new created overnight shift"
    end

    describe "editing overnight shifts" do
      let(:another_team) { create(:team) }

      it "updates the team of the second day" do
        # we need to provide overnight shift time attributes, so that the shift
        # stays an overnight shift after editing it
        overnight_shift.update_attributes!(
          start_hour: 22, start_minute: 15, end_hour: 6, end_minute: 45,
          team_id: another_team.id
        )

        overnight_shift.next_day.team.should eql(another_team)
      end

      it "updates the day of the second day" do
        # we need to provide overnight shift time attributes, so that the shift
        # stays an overnight shift after editing it
        overnight_shift.update_attributes!(
          start_hour: 22, start_minute: 15, end_hour: 6, end_minute: 45,
          day: 4
        )

        overnight_shift.next_day.day.should eql(5)
      end
    end

    describe "changing an overnight shift to a normal shift" do
      it "destroys the next day" do
        overnight_shift
        lambda {
          overnight_shift.update_attributes!(end_hour: 23, end_minute: 0)
        }.should change(Shift, :count).from(2).to(1)
      end

      context "saved and reloaded" do
        let(:normal_shift) { Shift.first }
        before :each do
          overnight_shift.update_attributes!(end_hour: 23, end_minute: 0)
        end

        it { normal_shift.start_hour.should == 22 }
        it { normal_shift.end_hour.should   == 23 }
        it { normal_shift.next_day.should be_nil }
      end
    end

    describe "destroying overnight shifts" do
      it "destroys the second day" do
        overnight_shift

        lambda {
          overnight_shift.destroy
        }.should change(Shift, :count).from(2).to(0)
      end
    end

    describe "changing a normal shift to an overnight shift" do
      let(:normal_shift) do
        create(:shift,
          day: 0,
          plan_template: plan_template,
          team: kitchen,
          demands_attributes: demands_attributes
        )
      end
      let(:overnight_shift) do
        normal_shift.update_attributes!(start_hour: 22, start_minute: 15, end_hour: 6, end_minute: 45)
        normal_shift.reload
      end

      it_behaves_like "a new created overnight shift"
    end
  end
end
