require 'spec_helper'

describe StackDecoratorHelper do
  before :each do
    class DecoratorForStackableRecords < RecordDecorator
      include StackDecoratorHelper
    end
  end
  let(:decorator) { DecoratorForStackableRecords.new(records) }
  let(:records) { stub }

  context '#stack_metadata_for scheduling' do
    let(:scheduling) { stub('Scheduling').as_null_object }
    let(:metadata) { decorator.stack_metadata_for(scheduling) }

    it "includes whole start hour" do
      scheduling.stub start_metric_hour: 9
      metadata[:start].should == 9
    end

    it "includes fractal start hour" do
      scheduling.stub start_metric_hour: 9.25
      metadata[:start].should == 9.25
    end

    it "includes whole-hour length" do
      scheduling.stub length_in_hours: 8
      metadata[:length].should == 8
    end

    it "includes fractal-hour length" do
      scheduling.stub length_in_hours: 8.75
      metadata[:length].should == 8.75
    end

    it "includes its stack" do
      scheduling.stub stack: 5
      metadata[:stack].should == 5
    end

    it 'includes the number of remaining stacks (negative position from back)' do
      scheduling.stub remaining_stack: 6
      metadata[:remaining].should == 6
    end

    it 'includes the total number of stacks' do
      scheduling.stub total_stack: 23
      metadata[:total].should == 23
    end

    it 'may use real data' do
      s = build(:scheduling_by_quickie, quickie: '9:15-11:45')
      s.stub stack: 3, remaining_stack: 2
      m = decorator.stack_metadata_for(s)
      m[:start].should == 9.25
      m[:length].should == 2.5
    end
  end

end
