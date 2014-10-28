describe TimeRangeComposer do
  let(:record) { instance_double 'Scheduling' }
  subject { described_class.new(record) }

  def time(stringy)
    Time.zone.parse(stringy)
  end

  context 'with base being a date' do
    let(:base) { time('2014-09-25').to_date }
    before :each do
      record.stub base_for_time_range_components: base
    end

    context '#starts_at' do
      it 'can be composed from date, hour and minute' do
        record.stub start_hour: 8, start_minute: 45
        subject.starts_at.should == time('2014-09-25 08:45')
      end
      it "accepts hour 0 as start of day" do
        record.stub start_hour: 0, start_minute: 15
        subject.starts_at.should == time('2014-09-25 00:15')
      end
    end

    context '#ends_at' do
      it 'can be composed from date, hour and minute' do
        record.stub end_hour: 16, end_minute: 15
        subject.ends_at.should == time('2014-09-25 16:15')
      end

      it "accepts hour 0 as end of day" do
        record.stub end_hour: 0, end_minute: 0
        subject.ends_at.should be_within(1.second).of( time('2014-09-25 23:59:59'))
      end

      xit "spans into next day for hour 0 and some minutes" do
        record.stub end_hour: 0, end_minute: 45
        subject.ends_at.should == time('2014-09-26 00:45')
      end

      it "accepts hour 24 as end of day" do
        record.stub end_hour: 24, end_minute: 0
        subject.ends_at.should be_within(1.second).of( time('2014-09-25 23:59:59'))
      end
    end

  end

end
