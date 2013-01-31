require 'spec_helper'

shared_examples "a new created overnight shift" do
  it "has a overnight mate" do
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
    nightshift.end_minute.should   ==  0

    morning_shift.start_hour.should   ==  0
    morning_shift.start_minute.should ==  0
    morning_shift.end_hour.should     ==  6
    morning_shift.end_minute.should   == 45
  end

  it "links the demands of the nightshift to the morning shift" do
    lambda {
      overnight_shift
    }.should change(Demand, :count).from(0).to(2)

    nightshift.demands.each do |demand|
      morning_shift.demands.should include(demand)
    end
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
  it "must have a start hour" do
    build(:shift, start_hour: nil).should_not be_valid
  end
  it "must have a start minute" do
    build(:shift, start_minute: nil).should_not be_valid
  end
  it "must have an end hour" do
    build(:shift, end_hour: nil).should_not be_valid
  end
  it "must have an end minute" do
    build(:shift, end_minute: nil).should_not be_valid
  end
  it "must have a day" do
    build(:shift, day: nil).should_not be_valid
  end
  it "must have a start time different from end time" do
    build(:shift, start_hour: 9, start_minute: 0, end_hour: 9, end_minute: 0).should_not be_valid
  end

  it "has a start hour >= 0 and an end hour <= 24" do
    build(:shift, start_hour: -1, end_hour: 20).should_not be_valid
    build(:shift, start_hour: 20, end_hour: 25).should_not be_valid
    build(:shift, start_hour: 0,  end_hour: 1 ).should be_valid
    build(:shift, start_hour: 22, end_hour: 24).should be_valid
  end

  [:start_minute, :end_minute].each do |start_or_end_minute|
    it "has a #{start_or_end_minute} of 0, 15, 30 or 45" do
      [0,15,30,45].each do |valid_minute|
        build(:shift, start_or_end_minute => valid_minute).should be_valid
        build(:shift, start_or_end_minute => valid_minute).should be_valid
        build(:shift, start_or_end_minute => valid_minute).should be_valid
        build(:shift, start_or_end_minute => valid_minute).should be_valid
      end
      [1,16,31,46].each do |invalid_minute|
        build(:shift, start_or_end_minute => invalid_minute).should_not be_valid
        build(:shift, start_or_end_minute => invalid_minute).should_not be_valid
        build(:shift, start_or_end_minute => invalid_minute).should_not be_valid
        build(:shift, start_or_end_minute => invalid_minute).should_not be_valid
      end
    end
  end

  it "destroys all its demands shifts when destroyed" do
    shift = create(:shift)
    shift.demands << create(:demand)
    shift.demands << create(:demand)

    lambda {
      shift.destroy
    }.should change(DemandsShifts, :count).from(2).to(0)
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
      it "destroys the overnight mate" do
        overnight_shift

        lambda {
          overnight_shift.update_attributes!(end_hour: 23)
        }.should change(Shift, :count).from(2).to(1)

        normal_shift = Shift.first
        normal_shift.start_hour.should == 22
        normal_shift.end_hour.should   == 23
        normal_shift.next_day.should be_nil
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
