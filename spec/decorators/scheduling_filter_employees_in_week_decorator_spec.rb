require 'spec_helper'

describe SchedulingFilterEmployeesInWeekDecorator do
  before { ApplicationController.new.set_current_view_context }

  let(:filter)    { Scheduling.filter }
  let(:decorator) { described_class.new(filter) }

  context "for scheduling" do
    it "should provide wrappers" do
      day        = mock 'day'
      employee   = mock 'Employee'

      starts_at  = mock 'starts_at', day: day
      scheduling = mock 'Scheduling', employee: employee, date: day

      decorator.should_receive(:fnord).with( day, employee ).and_return("the fnord")
      decorator.fnord_for_scheduling(scheduling)
    end
  end

  it "sorts schedulings by start hour" do
    employee = Factory :employee
    schedulings = [
      Factory(:scheduling, start_hour: 23),
      Factory(:scheduling, start_hour: 6),
      Factory(:scheduling, start_hour: 17)
    ]
    filter.should_receive(:indexed).with(3, employee).and_return( schedulings )
    decorator.schedulings_for(3, employee).map(&:start_hour).should == [6,17,23]
  end
end

