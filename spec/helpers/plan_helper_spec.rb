require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PlanHelper do
  before(:each) do
    @plan = Plan.new(
      :name  => 'Plan 1',
      :start => Time.local(2009, 9, 7, 8, 30),
      :end   => Time.local(2009, 9, 11, 16, 30)
    )
  end

  describe "#dates" do
    it "should return the dates as string" do
      helper.plan_dates(@plan).should == '2009-09-07 - 2009-09-11'
    end
  end

  describe "#name_and_dates" do
    it "should return the name and dates as string" do
      helper.plan_name_and_dates(@plan).should == 'Plan 1 (2009-09-07 - 2009-09-11)'
    end
  end
end
