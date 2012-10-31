require 'spec_helper'

describe SchedulingFilterDecorator, 'mode' do
  let(:filter) { SchedulingFilter.new }
  it "selects the decorator by given mode" do
    decorator = mock('Decorator')
    SchedulingFilterEmployeesInWeekDecorator.should_receive(:new).with(filter, {foo: 23}).and_return(decorator)
    SchedulingFilterHoursInWeekDecorator.should_not_receive(:new)
    SchedulingFilterDecorator.decorate(filter, {foo: 23, mode: 'employees_in_week'}).should == decorator
  end

  it "should deny any unknown modes" do
    expect { SchedulingFilterDecorator.decorate(filter, mode: 'with_blackjack_and_hookers') }.to raise_error
  end

  it "plan period for plan with start and end date" do
    plan = build :plan, starts_at: Time.zone.parse('2012-12-12'), ends_at: Time.zone.parse('2012-12-24')
    filter = SchedulingFilter.new plan: plan
    decorator = SchedulingFilterDecorator.new(filter)
    decorator.plan_period.should == "Beginnt: 12.12.2012 Endet: 24.12.2012"
  end

  it "plan period for plan with only start date" do
    plan = build :plan, starts_at: Time.zone.parse('2012-12-12')
    filter = SchedulingFilter.new plan: plan
    decorator = SchedulingFilterDecorator.new(filter)
    decorator.plan_period.should == "Beginnt: 12.12.2012"
  end

  it "plan period for plan with only end date" do
    plan = build :plan, ends_at: Time.zone.parse('2012-12-24')
    filter = SchedulingFilter.new plan: plan
    decorator = SchedulingFilterDecorator.new(filter)
    decorator.plan_period.should == "Endet: 24.12.2012"
  end
end
