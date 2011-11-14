require 'spec_helper'

describe Scheduling do
  context "setting quicky" do
    it "sets start and ends date" do
      input = '9-17'
      the_day = Time.zone.parse('2011-01-02').to_date

      quicky = mock 'Quickie',
        :to_s => input,
        :start_hours => 9.hours,
        :end_hours => 17.hours
      Quicky.should_receive(:parse).with(input).and_return(quicky)

      plan = mock_model('Plan')
      plan.stub!(:day_at).with(23).and_return(the_day)

      s = Factory.build :scheduling, :plan => plan, :quicky => input, :day => 23
      s.valid? # enforce parsing of quicky

      s.starts_at.should == Time.zone.parse('2011-01-02 09:00')
      s.ends_at.should == Time.zone.parse('2011-01-02 17:00')
    end
  end
end
