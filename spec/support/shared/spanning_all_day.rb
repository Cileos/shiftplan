shared_examples :spanning_all_day do
  it 'starts at midnight' do
    record.start_time.should == '00:00'
    record.starts_at.hour.should == 0
    record.starts_at.min.should == 0
  end

  it 'ends at next midnight' do
    record.end_time.should == '23:59'
    record.ends_at.hour.should == 23
    record.ends_at.min.should == 59
  end

  it "lasts 24 hours" do
    (record.ends_at - record.starts_at).should be_within(60.seconds).of(24.hours)
  end

  it 'has a zero length_in_hours (does not count into wwt)' do
    record.length_in_hours.should == 0
  end
end
