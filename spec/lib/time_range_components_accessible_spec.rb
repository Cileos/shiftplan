require 'spec_helper'



describe TimeRangeComponentsAccessible do
  before :each do
    class ObjectWithTimeRanges
      stub :before_validation
      attr_accessor :starts_at, :ends_at, :date

      include TimeRangeComponentsAccessible
    end
  end
  let(:m) { ObjectWithTimeRanges.new }

  it 'accepts full start_time' do
    m.start_time = '19:00'
    m.start_hour.should == 19
    m.start_minute.should == 00
    m.start_time.should == '19:00'
  end

  it 'accepts short start_time' do
    m.start_time = '9'
    m.start_hour.should == 9
    m.start_minute.should == 0
    m.start_time.should == '09:00'
  end

  context '15 minutes' do
    it 'are rounded up' do
      m.start_time = '19:59'
      m.start_minute.should == 00
      m.start_hour.should == 20
      m.start_time.should == '20:00'
    end

    it 'are rounded down' do
      m.start_time = '19:52'
      m.start_hour.should == 19
      m.start_minute.should == 45
      m.start_time.should == '19:45'
    end
  end
end

describe TimeComponent do
  let(:record) { double 'record' }
  subject { described_class.new(record, :start) }

  context '#round_minute' do
    {
       0 => 0,
       1 => 0,
       5 => 0,
       7 => 0,
       8 => 15,
       9 => 15,
      22 => 15,
      23 => 30,
      27 => 30,
      37 => 30,
      38 => 45,
      52 => 45,
      53 => 0,
      57 => 0,
      59 => 0
    }.each do |min, rounded|
        it("rounds #{min} => #{rounded}") { subject.round_minute(min).should == rounded }
      end
  end

  context '#metric_hour' do
    it "does not touch full hours" do
      subject.stub hour: 4, minute: 0
      subject.metric_hour.should eq(4)
    end

    it "adds .25 for 15 minutes" do
      subject.stub hour: 4, minute: 15
      subject.metric_hour.should == 4.25
    end

    it "adds .5 for 30 minutes" do
      subject.stub hour: 4, minute: 30
      subject.metric_hour.should == 4.5
    end

    it "adds .75 for 45 minutes" do
      subject.stub hour: 4, minute: 45
      subject.metric_hour.should == 4.75
    end
  end
end
