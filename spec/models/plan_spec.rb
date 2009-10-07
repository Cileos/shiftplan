require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Plan do
  def monday_morning
    @monday ||= Time.parse('2009-09-07 08:30')
  end

  def friday_afternoon
    @friday ||= Time.parse('2009-09-11 16:30')
  end

  before(:each) do
    @plan = Plan.new do |p|
      p.account_id = 1
      p.start      = monday_morning
      p.end        = friday_afternoon
      p.duration   = 8 * 60

      p.shifts = [Shift.new(:start => monday_morning, :end => friday_afternoon)]
    end
  end

  describe "associations" do
    it "has many shifts" do
      @plan.shifts.should_not be_empty
    end
  end


  describe "validations" do
  end

  describe "callbacks" do
    it "should set the duration from start/end time before validation" do
      @plan.duration = nil
      @plan.valid?
      @plan.duration.should == 8 * 60
    end
  end

  it "days returns a range of days from start_day to end_day" do
    @plan.days.should == (Date.parse('2009-09-07')..Date.parse('2009-09-11'))
  end

  it "start_in_minutes returns the start_time in minutes" do
    @plan.start_time_in_minutes.should == 8 * 60 + 30
  end

  it "end_in_minutes returns the end_time in minutes" do
    @plan.end_time_in_minutes.should == 16 * 60 + 30
  end
end