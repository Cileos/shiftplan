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
  it "must have an end hour" do
    build(:shift, end_hour: nil).should_not be_valid
  end
  it "must have a day" do
    build(:shift, day: nil).should_not be_valid
  end

  # TODO: comment in again, when our scheduling support minutes, too
  # it "must have a start minute" do
  #   build(:shift, start_minute: nil).should_not be_valid
  # end
  # it "must have an end minute" do
  #   build(:shift, end_minute: nil).should_not be_valid
  # end

  [:start_hour, :end_hour].each do |start_or_end_hour|
    it "must have a #{start_or_end_hour} between 0 and 23" do
      build(:shift, start_or_end_hour => -1).should_not be_valid
      build(:shift, start_or_end_hour => 24).should_not be_valid
      build(:shift, start_or_end_hour => 0).should be_valid
      build(:shift, start_or_end_hour => 23).should be_valid
    end
  end
  [:start_minute, :end_minute].each do |start_or_end_minute|
    it "must have a #{start_or_end_minute} between 0 and 59" do
      build(:shift, start_or_end_minute => -1).should_not be_valid
      build(:shift, start_or_end_minute => 60).should_not be_valid
      build(:shift, start_or_end_minute => 0).should be_valid
      build(:shift, start_or_end_minute => 59).should be_valid
    end
  end
end
