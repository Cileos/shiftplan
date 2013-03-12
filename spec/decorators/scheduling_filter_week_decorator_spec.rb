require 'spec_helper'

describe SchedulingFilterWeekDecorator do
  let(:filter)    { SchedulingFilter.new }
  let(:decorator) { described_class.new filter }

  it "contains only records in queried week"
  it "does not contain records outside queried week"
  it "groups records by week and y axis"

  it "indexes records their date#iso8601" do
    index = stub
    decorator.stub(:index).and_return(index)
    day = stub iso8601: 'iso8601'
    index.should_receive(:fetch).with('iso8601', 'b').and_return('lots')
    decorator.indexed(day, 'b').should == 'lots'
  end
end
