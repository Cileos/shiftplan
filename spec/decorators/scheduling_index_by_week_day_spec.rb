describe SchedulingIndexByWeekDay do
  it 'is two dimensional' do
    described_class.should < TwoDimensionalRecordIndex
  end

  context 'for any other y' do
    def s(date, team, is_overnight=false)
      instance_double 'Scheduling', date: date, team: team, is_overnight?: is_overnight
    end
    subject { described_class.new(:team) }

    let(:day1) { Time.zone.parse '2014-09-24' }
    let(:day2) { Time.zone.parse '2014-09-25' }
    let(:day3) { Time.zone.parse '2014-09-27' }

    let(:one) { s(day1, 'one') }
    let(:two) { s(day2, 'two') }

    it 'uses days as keys' do
      subject << one
      subject << two
      subject.keys.should == [day1,day2]

      subject.fetch(day1, 'one').should include(one)
      subject.fetch(day2, 'two').should include(two)
    end

    let(:three) { s(day3, 'three', true) }
    it 'indexes overnightable also for the next day' do
      subject << three
      subject.fetch(day3, 'three').should include(three)
      subject.fetch(day3.tomorrow, 'three').should include(three)
    end

  end
end
