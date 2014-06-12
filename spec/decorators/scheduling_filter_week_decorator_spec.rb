require 'spec_helper'

describe SchedulingFilterWeekDecorator do
  let(:filter)    { SchedulingFilter.new }
  let(:decorator) { described_class.new filter }

  it "contains only records in queried week"
  it "does not contain records outside queried week"
  it "groups records by week and y axis"

  it "indexes schedulings their date#iso8601" do
    index = double
    decorator.stub(:scheduling_index).and_return(index)
    day = double iso8601: 'iso8601'
    records = [instance_double('Scheduling', start_hour: 9)]
    index.should_receive(:fetch).with('iso8601', 'b').and_return(records)
    decorator.schedulings_for(day, 'b').should == records
  end

  it "indexes unavailabilities their date#iso8601" do
    index = double
    decorator.stub(:unavailabilities_index).and_return(index)
    day = double iso8601: 'iso8601'
    records = [instance_double('Unavailability', start_hour: 9)]
    index.should_receive(:fetch).with('iso8601', 'b').and_return(records)
    decorator.unavailabilities_for(day, 'b').should == records
  end

  describe '#formatted_days' do
    it 'provides class for today' do # false is skipped by haml
      filter.stub days: [1.day.ago, 0.day.ago, 1.day.from_now].map(&:to_date)
      decorator.formatted_days.map { |f| f.last[:class] }.should == [false, 'today', false]
    end
  end
end
