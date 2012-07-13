require 'spec_helper'

describe SchedulingFilterWeekDecorator do
  let(:filter)    { SchedulingFilter.new }
  let(:decorator) { described_class.new filter }
end
