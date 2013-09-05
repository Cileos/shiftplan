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
      metadata[:start].should == '9'
    end

    it "rounds down to whole start hour" do
      scheduling.stub start_metric_hour: 9.1
      metadata[:start].should == '9'
    end

    it "includes fractal start hour" do
      scheduling.stub start_metric_hour: 9.25
      metadata[:start].should == '9.25'
    end

    it "includes whole-hour length" do
      scheduling.stub length_in_hours: 8.0
      metadata[:length].should == '8'
    end

    it "includes fractal-hour length" do
      scheduling.stub length_in_hours: 8.75
      metadata[:length].should == '8.75'
    end

    it "includes its stack" do
      scheduling.stub stack: 5
      metadata[:stack].should == '5'
    end

    it 'includes the number of remaining stacks (negative position from back)' do
      scheduling.stub remaining_stack: 6
      metadata[:remaining].should == '6'
    end

    it 'includes the total number of stacks' do
      scheduling.stub total_stack: 23
      metadata[:total].should == '23'
    end

    it 'may use real data' do
      s = build(:scheduling_by_quickie, quickie: '9:15-11:45')
      s.stub stack: 3, remaining_stack: 2
      m = decorator.stack_metadata_for(s)
      m[:start].should == '9.25'
      m[:length].should == '2.5'
    end

    context '0-length scheduling' do
      let(:scheduling) { build :scheduling_by_quickie, quickie: '8-8' }
      let(:records) { [scheduling] }
      before :each do
        decorator.pack_in_stacks records
      end
      it 'is shown with length of 0.25' do
        metadata[:length].should == '0.25'
      end

      it 'has no stack remaining' do
        metadata[:remaining].should == '0'
      end

      it 'has 1 stack total' do
        metadata[:total].should == '1'
      end
    end

    context 'two 0-length schedulings at the same time' do
      before :each do
        decorator.pack_in_stacks records
      end
      let(:scheduling) { build :scheduling_by_quickie, quickie: '8-8' }
      let(:scheduling2) { build :scheduling_by_quickie, quickie: '8-8' }
      let(:records) { [scheduling, scheduling2] }
      let(:metadata2) { decorator.stack_metadata_for(scheduling2) }

      it 'are packed in two different stacks' do
        metadata[:stack].should_not == metadata2[:stack]
      end
    end
  end

end
