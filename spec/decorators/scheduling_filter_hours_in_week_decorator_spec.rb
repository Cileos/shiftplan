require 'spec_helper'

describe SchedulingFilterHoursInWeekDecorator do
  let(:filter)    { SchedulingFilter.new }
  let(:decorator) { described_class.new filter }
  def build_shifts(*quickies)
    quickies.map { |q| create :scheduling, quickie: q }
  end
  
  context 'stacks of' do
    let(:stacks) { decorator.pack_in_stacks( build_shifts(*shifts) ).map(&:stack) }
    let(:remaining_stacks) { decorator.pack_in_stacks( build_shifts(*shifts) ).map(&:remaining_stack) }

    context "non-overlapping shifts" do
      let(:shifts) { %w(9-10 10-11 12-14) }
      it "are packed in same stack" do
        stacks.should == [0,0,0]
      end

      it "have no remaining stacks" do
        remaining_stacks.should == [0,0,0]
      end
    end

    context "overlapping shifts" do
      let(:shifts) { %w(9-15 10-13) }
      it "are packed in different stacks" do
        stacks.should == [0,1]
      end

      it "have decreasing remaining stacks" do
        remaining_stacks.should == [1,0]
      end
    end

    context "cascading shifts" do
      let(:shifts) { %w(9-17 9-17 10-16 11-15 11-14) }
      it "are packed in different stacks" do
        stacks.should == [0,1,2,3,4]
      end

      it "have decreasing remaining stacks" do
        remaining_stacks.should == [4,3,2,1,0]
      end
    end

    context "alternating shifts" do
      let(:shifts) { %w(9-12 10-13 12-14 13-14) }
      it "are packed in different stacks" do
        stacks.should == [0,1,0,1]
      end

      it "should alternate remaining stack" do
        remaining_stacks.should == [1,0,1,0]
      end
    end
  end

end
