require 'spec_helper'

describe Plan do
  context 'duration' do
    it "should default to 1 month" do
      plan = described_class.new
      plan.duration.should == '1_month'
    end
  end
  context 'last_day' do
    it "is set automatically when first_day and duration is given" do
      plan = Factory(:plan, :first_day => Date.today.beginning_of_month)
      plan.last_day.should == Date.today.end_of_month
    end
  end

  context 'duration_in_days' do
    it "should handle months with 30 days" do
      Factory(:plan, :first_day => '2011-09-01').duration_in_days.should == 30
    end
    it "should handle months with 31 days" do
      Factory(:plan, :first_day => '2011-10-01').duration_in_days.should == 31
    end
  end

  context 'each_day' do
    it "should depend on duration_in_days" do
      plan = Factory(:plan, :first_day => '2011-10-01')
      plan.should_receive(:duration_in_days).and_return(30)

      days = []
      plan.each_day {|d| days << d}
      days.should have(30).items
      days.map(&:day).should == (1..30).to_a
    end
  end

  context "day_at" do
    it "should calculate the nth day of the plan" do
      plan = Factory.build :plan, :first_day => Date.parse("2011-02-01")
      plan.day_at(1).should be_a(ActiveSupport::TimeWithZone)
      plan.day_at(1).should  == Time.zone.parse("2011-02-01")
      plan.day_at(3).should  == Time.zone.parse("2011-02-03")
      plan.day_at(7).should  == Time.zone.parse("2011-02-07")
      plan.day_at(23).should == Time.zone.parse("2011-02-23")
    end
  end
end
