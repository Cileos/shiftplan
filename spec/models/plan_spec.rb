require 'spec_helper'

describe Plan do
  context 'duration' do
    it "should default to 1 week" do
      plan = described_class.new
      plan.duration.should == '1_week'
    end
  end

end
