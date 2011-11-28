require 'spec_helper'

describe Quicky do
  it "should parse simple time span" do
    q = Quicky.parse('9-17')
    q.start_hour.should == 9
    q.end_hour.should == 17
    q.start_hours.should == 9.hours
    q.end_hours.should == 17.hours
  end
end