require 'spec_helper'

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
  it "has a start hour smaller than the end hour" do
    build(:shift, start_hour: 16, end_hour: 15).should_not be_valid
    build(:shift, start_hour: 16, end_hour: 16).should_not be_valid
  end

  it "must have a start hour >= 0 and an end hour < 24" do
    build(:shift, start_hour: -1, end_hour: 20).should_not be_valid
    build(:shift, start_hour: 20, end_hour: 24).should_not be_valid
    build(:shift, start_hour: 0,  end_hour: 1).should be_valid
    build(:shift, start_hour: 22, end_hour: 23).should be_valid
  end

  [:start_minute, :end_minute].each do |start_or_end_minute|
    it "must have a #{start_or_end_minute} of 0, 15, 30 or 45" do
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
end
