describe TimeRangeComposer do
  let(:record) { instance_double 'Scheduling' }
  subject { described_class.new(record) }

  context 'with base being a date' do
    let(:base) { Time.zone.parse('2014-09-25').to_date }
    before :each do
      record.stub base_for_time_range_components: base
    end

    context '#starts_at' do
      it 'can be composed from date, hour and minute' do
        record.stub start_hour: 8, start_minute: 45, start_hour_present?: true
        subject.starts_at.should == Time.zone.parse('2014-09-25 08:45')
      end
      it "accepts zero hour as start of day"
    end

    context '#ends_at' do
      it 'can be composed from date, hour and minute' do
        record.stub end_hour: 16, end_minute: 15, end_hour_present?: true
        subject.ends_at.should == Time.zone.parse('2014-09-25 16:15')
      end
      it "accepts hour 0 as end of day"

      it "accepts hour 24 as end of day"
    end

  end

end
