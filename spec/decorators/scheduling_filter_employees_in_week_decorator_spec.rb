require 'spec_helper'

describe SchedulingFilterEmployeesInWeekDecorator do

  let(:filter)    { Scheduling.filter }
  let(:decorator) { described_class.new(filter) }

  before(:each) do
    filter.stub date: Time.zone.now
  end

  it "sorts schedulings by start hour" do
    employee = create :employee
    schedulings = [
      create(:scheduling, start_hour: 23),
      create(:scheduling, start_hour: 6),
      create(:scheduling, start_hour: 17)
    ]
    day = double('day')
    decorator.should_receive(:indexed).with(day, employee).and_return( schedulings )
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

