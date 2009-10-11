require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Plan do
  def monday_morning
    @monday ||= Time.local(2009, 9, 7, 8, 30)
  end

  def friday_afternoon
    @friday ||= Time.local(2009, 9, 11, 16, 30)
  end

  before(:each) do
    @plan = Plan.new
  end

  describe "associations" do
    it "should have shifts" do
      @plan.should have_many(:shifts)
    end
  end


  describe "validations" do
  end

  describe "callbacks" do
    describe "#set_duration" do
      before(:each) do
        @plan.start = monday_morning
        @plan.end   = friday_afternoon
      end

      it "should set the duration from start/end time before validation" do
        @plan.duration = nil
        @plan.valid? # @plan.send(:set_duration) # ?
        @plan.duration.should == 8 * 60
      end
    end
  end

  describe "instance methods" do
    describe "#days" do
      before(:each) do
        @plan.start = monday_morning
        @plan.end   = friday_afternoon
      end

      it "should return a range of days from start day to end day" do
        @plan.days.should == (Date.civil(2009, 9, 7)..Date.civil(2009, 9, 11))
      end
    end

    describe "#start_time_in_minutes" do
      before(:each) do
        @plan.start = monday_morning
        @plan.end   = friday_afternoon
      end

      it "should return the start time in minutes" do
        @plan.start_time_in_minutes.should == 8 * 60 + 30
      end
    end

    describe "#end_time_in_minutes" do
      before(:each) do
        @plan.start = monday_morning
        @plan.end   = friday_afternoon
      end

      it "should return the end time in minutes" do
        @plan.end_time_in_minutes.should == 16 * 60 + 30
      end
    end
  end
end
