require 'spec_helper'

describe SchedulingFilterHoursInWeekDecorator do
  let(:filter)    { SchedulingFilter.new }
  let(:decorator) { described_class.new filter }
  
  context 'pack in stacks' do
    def shifts(*quickies)
      quickies.map { |q| create :scheduling, quickie: q }
    end

    def packed(*quickies)
      decorator.pack_in_stacks( shifts(*quickies) ).map(&:stack)
    end

    it "puts non-overlapping schedulings in same stack" do
      packed('9-10', '10-11', '12-14').should == [0,0,0]
    end
    it "puts overlapping scheduling in a new stack" do
      packed('9-15', '10-13').should == [0,1]
    end
    it "creates as many stack as needed" do
      packed('9-17', '9-17', '10-16', '11-15', '11-14').should == [0,1,2,3,4]
    end
    it "should ont waste stacks" do
      packed('9-12', '10-13', '12-14').should == [0,1,0]
    end
  end

end
