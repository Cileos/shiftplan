require 'spec_helper'

describe SchedulingFilterDecorator, 'mode' do
  let(:filter) { SchedulingFilter.new }
  let(:opts) { {foo:23} }
  it "selects the decorator by given mode" do
    decorator = mock('Decorator')
    SchedulingFilterEmployeesInWeekDecorator.should_receive(:new).with(filter, opts).and_return(decorator)
    SchedulingFilterHoursInWeekDecorator.should_not_receive(:new)
    SchedulingFilterDecorator.decorate_with_mode(filter, 'employees_in_week', opts).should == decorator
  end
  
  it "should deny any unknown modes" do
    expect { SchedulingFilterDecorator.decorate_with_mode(filter, 'with_blackjack_and_hookers') }.to raise_error
  end
end
