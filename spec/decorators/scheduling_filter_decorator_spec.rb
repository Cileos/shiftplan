require 'spec_helper'

describe SchedulingFilterDecorator do
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
end
