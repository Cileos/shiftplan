describe ShiftIndexByNumericDay do
  it 'is two dimensional' do
    described_class.should < TwoDimensionalRecordIndex
  end

  context 'for any other y' do
    def s(day, team, is_overnight=false)
      instance_double 'Shift', day: day, team: team, is_overnight?: is_overnight
    end
    subject { described_class.new(:team) }

    let(:one) { s(1, 'one') }
    let(:two) { s(3, 'two') }

    it 'uses days as keys' do
      subject << one
      subject << two
      subject.keys.should == [1,3]

      subject.fetch(1, 'one').should include(one)
      subject.fetch(3, 'two').should include(two)
    end

    let(:three) { s(6, 'three', true) }
    it 'indexes overnightable also for the next day' do
      subject << three
      subject.fetch(6, 'three').should include(three)
      subject.fetch(7, 'three').should include(three)
    end

  end
end
