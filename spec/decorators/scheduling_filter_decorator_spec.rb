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
end
