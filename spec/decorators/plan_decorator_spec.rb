require 'spec_helper'

describe PlanDecorator do
  before { ApplicationController.new.set_current_view_context }

  let(:plan) { Factory :plan }
  let(:decorator) { described_class.new(plan) }

  context "for scheduling" do
    it "should provide wrappers" do
      day        = mock 'day'
      employee   = mock 'Employee'

      starts_at  = mock 'starts_at', day: day
      scheduling = mock 'Scheduling', employee: employee, starts_at: starts_at

      decorator.should_receive(:fnord).with( employee, day ).and_return("the fnord")
      decorator.fnord_for_scheduling(scheduling)
    end
  end
end
