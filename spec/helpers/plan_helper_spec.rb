require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PlanHelper do
  before(:each) do
    @plan = Plan.new(
      :name  => 'Plan 1',
      :start_date => Date.civil(2009, 9, 7),
      :end_date   => Date.civil(2009, 9, 11)
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
