require 'spec_helper'

describe Scheduling do
  context "setting quickie" do
    it "sets start and ends date" do
      input = '9-17'
      the_day = Time.zone.parse('2011-01-02').to_date

      plan = mock_model('Plan')
      plan.stub!(:day_at).with(23).and_return(the_day)

      s = Factory.build :scheduling, :plan => plan, :quickie => input, :day => 23
      s.valid? # enforce parsing of quickie

      s.starts_at.should == Time.zone.parse('2011-01-02 09:00')
      s.ends_at.should == Time.zone.parse('2011-01-02 17:00')
    end
  end
end
