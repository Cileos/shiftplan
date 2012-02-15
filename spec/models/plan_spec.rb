require 'spec_helper'

describe Plan do
  context 'week' do
    it "should validate first and last day" do
      plan = Factory.build :plan, first_day: '2011-10-01' # saturday
      plan.should_not be_valid
      plan.should have_at_least(1).errors_on(:first_day)
      plan.should have_at_least(1).errors_on(:last_day)
    end
  end

  context 'duration' do
    it "should default to 1 weej" do
      plan = described_class.new
      plan.duration.should == '1_week'
    end
  end
  context 'last_day' do
    it "is set automatically when first_day and duration is given" do
      plan = Factory :plan, first_day: Date.today.beginning_of_week
      plan.last_day.should == Date.today.end_of_week
    end
  end

  context 'duration_in_days' do
    it "should always span a week" do
      plan = Factory(:plan)
      plan.duration_in_days.should == 7
    end
  end

  context 'days' do
    it "should depend on duration_in_days" do
      plan = Factory.build :plan, first_day: '2011-10-03'
      plan.should_receive(:duration_in_days).and_return(23)

      days = plan.days
      days.should have(23).items
      days.map(&:day).should == (3..25).to_a
    end
  end

  context "day_at" do
    it "should calculate the nth day of the plan" do
      plan = Factory.build :plan, first_day: Date.parse("2011-02-01")
      plan.day_at(1).should be_a(Date)
      plan.day_at(1).should  == Time.zone.parse("2011-02-01").to_date
      plan.day_at(3).should  == Time.zone.parse("2011-02-03").to_date
      plan.day_at(7).should  == Time.zone.parse("2011-02-07").to_date
      plan.day_at(23).should == Time.zone.parse("2011-02-23").to_date
    end
  end
end
