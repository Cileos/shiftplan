require 'spec_helper'

describe SchedulingFilterWeekDecorator do
  let(:filter)    { SchedulingFilter.new }
  let(:decorator) { described_class.new filter }

  it "contains only records in queried week"
  it "does not contain records outside queried week"
  it "groups records by week and y axis"

  let(:day) { double("Day", iso8601: 'iso8601').tap { |d| d.stub to_date: d } }

  let(:scheduling) { instance_double('Scheduling', starts_at: 42, :focus_day= => true) }
  it "indexes schedulings their date#iso8601" do
    index = instance_double 'SchedulingIndexByWeekDay'
    decorator.stub(:scheduling_index).and_return(index)
    scheduling.stub decorate: scheduling
    records = [scheduling]
    index.should_receive(:fetch).with(day, 'b').and_return(records)
    decorator.schedulings_for(day, 'b').should == records
  end

  it "indexes unavailabilities their date#iso8601" do
    index = instance_double 'TwoDimensionalRecordIndex'
    decorator.stub(:unavailabilities_index).and_return(index)
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
