require 'spec_helper'

describe SchedulingFilterWeekDecorator do
  let(:filter)    { SchedulingFilter.new }
  let(:decorator) { described_class.new filter }

  it "contains only records in queried week"
  it "does not contain records outside queried week"
  it "groups records by week and y axis"
end
