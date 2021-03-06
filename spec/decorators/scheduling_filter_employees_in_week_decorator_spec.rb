require 'spec_helper'

describe SchedulingFilterEmployeesInWeekDecorator do

  let(:filter)    { Scheduling.filter }
  let(:decorator) { described_class.new(filter) }

  before(:each) do
    filter.stub date: Time.zone.now
  end

  let(:day) { double("Day", iso8601: 'iso8601').tap { |d| d.stub to_date: d } }

  it "sorts schedulings by start hour" do
    employee = create :employee
    schedulings = [
      create(:scheduling, start_hour: 23, end_hour: 24),
      create(:scheduling, start_hour: 6,  end_hour: 24),
      create(:scheduling, start_hour: 17, end_hour: 24)
    ]
    index = instance_double('TwoDimensionalRecordIndex')
    decorator.stub scheduling_index: index
    index.should_receive(:fetch).and_return( schedulings )
    decorator.schedulings_for(day, employee).map(&:start_hour).should == [6,17,23]
  end

  context "cell metadata" do
    let(:day) { double 'Date', iso8601: 'in_iso8601' }

    it "sets employee-id and date" do
      employee = double 'Employee', id: 23
      decorator.cell_metadata(day,employee).
        should be_hash_matching(:'employee-id' => 23,
                                :date => 'in_iso8601')
    end

    it "sets employee-id to 'missing' without emplyoee" do
      decorator.cell_metadata(day,nil).
        should be_hash_matching(:'employee-id' => 'missing',
                                :date => 'in_iso8601')
    end
  end

end

