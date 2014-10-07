require 'spec_helper'

shared_examples "a new created overnight shift" do
  it "creates one shifts" do # no overnightable split
    lambda {
      overnight_shift
    }.should change(Shift, :count).from(0).to(1)
  end

  it "spans the hour ranges of the shifts over midnight" do
    overnight_shift

    nightshift.start_hour.should   == 22
    nightshift.start_minute.should == 15
    nightshift.end_hour.should     == 6
    nightshift.end_minute.should   == 45

    nightshift.starts_at.should < nightshift.ends_at
  end

  it "delegates the demands of the next day to the previous day" do
    lambda {
      overnight_shift
    }.should change(Demand, :count).from(0).to(2)

    nightshift.should have(2).demands
  end

  it "copies the teams to the morning shift" do
    overnight_shift

    nightshift.team.should eql(kitchen)
  end

  it "copies the plan template" do
    overnight_shift

    nightshift.plan_template.should eql(plan_template)
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
  it "must have a start time different from the end time" do
    build(:shift,
      start_hour: 8,
      start_minute: 0,
      end_hour: 8,
      end_minute: 0).should_not be_valid
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

    describe "creating overnight shifts" do
      it_behaves_like "a new created overnight shift"
    end

    describe "editing overnight shifts" do
      let(:another_team) { create(:team) }

      # niklas does not understand how shifts calculate their ends_at etc
      xit "updates the day" do
        # we need to provide overnight shift time attributes, so that the shift
        # stays an overnight shift after editing it
        overnight_shift.update_attributes!(
          start_hour: 22, start_minute: 15, end_hour: 6, end_minute: 45,
          day: 4
        )

        overnight_shift.end_day.should eql(5)
      end
    end

    describe "changing an overnight shift to a normal shift" do
      it "destroys nothing" do # no overnightable split
        overnight_shift
        lambda {
          overnight_shift.update_attributes!(end_hour: 23, end_minute: 0)
        }.should_not change(Shift, :count)
      end

      context "saved and reloaded" do
        let(:normal_shift) { Shift.first }
        before :each do
          overnight_shift.update_attributes!(end_hour: 23, end_minute: 0)
        end

        it { normal_shift.start_hour.should == 22 }
        it { normal_shift.end_hour.should   == 23 }
      end
    end

    describe "destroying overnight shifts" do
      it "destroys one record" do # no overnight splitting
        overnight_shift

        lambda {
          overnight_shift.destroy
        }.should change(Shift, :count).from(1).to(0)
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

  it_behaves_like :spanning_all_day do
    let(:record) { create :shift, all_day: true }
  end
end
