require 'spec_helper'

describe SchedulingFilterEmployeesInWeekDecorator do

  let(:filter)    { Scheduling.filter }
  let(:decorator) { described_class.new(filter) }

  it "sorts schedulings by start hour" do
    employee = create :employee
    schedulings = [
      create(:scheduling, start_hour: 23),
      create(:scheduling, start_hour: 6),
      create(:scheduling, start_hour: 17)
    ]
    day = mock('day')
    decorator.should_receive(:indexed).with(day, employee).and_return( schedulings )
    decorator.schedulings_for(day, employee).map(&:start_hour).should == [6,17,23]
  end

  # for performance reasons, we do not want to search through all the available schedulings for each cell, so we index them
  context "index" do
    let(:bad_day) { mock('Date', iso8601: '2011-sometimes') }

    context "scheduled nothing" do
      context "index accessor" do
        it "should return empty array" do
          filter.stub date: Time.zone.now
          decorator.indexed(bad_day, 42).should == []
        end
      end
    end

    context "scheduled a lot" do
      let(:plan)   { create :plan }
      let(:filter) { SchedulingFilter.new week: 52, cwyear: 2012, plan: plan }
      let(:me)     { create :employee }
      let(:you)    { create :employee }
      before :each do
        @waiting = create :manual_scheduling, plan: plan, year: 2012, week: 52, cwday: 1, employee: you
        @opening = create :manual_scheduling, plan: plan, year: 2012, week: 52, cwday: 2, employee: you
        @eating1 = create :manual_scheduling, plan: plan, year: 2012, week: 52, cwday: 3, employee: you
        @eating2 = create :manual_scheduling, plan: plan, year: 2012, week: 52, cwday: 3, employee: me
      end
      let(:i) { decorator.index }

      it "should index the records by their date" do
        i.keys.should include(@waiting.iso8601)
        i.keys.should include(@opening.iso8601)
        i.keys.should include(@eating1.iso8601)
        i.keys.should include(@eating2.iso8601)
      end

      it "should index by iso8601 and employee" do
        i[@waiting.iso8601].keys.should have(1).record
        i[@waiting.iso8601].keys.should include(@waiting.employee)
        i[@waiting.iso8601][@waiting.employee].should == [@waiting]

        i[@opening.iso8601][@opening.employee].should == [@opening]
      end

      it "should group to scheduling on the same day" do
        i[@eating1.iso8601][@eating1.employee].should == [@eating1]
        i[@eating1.iso8601][@eating2.employee].should == [@eating2]
        #       ^^^ grouped on 
      end

      context "index accessor" do
        it "find the records" do
          decorator.indexed(@eating1.date, @eating1.employee).should == [@eating1]
        end

        it "does not break if nothing found" do
          expect { decorator.indexed(bad_day, 42) }.not_to raise_error
        end

        it "returns empty array when nothing found" do
          decorator.indexed(bad_day, 42).should == []
        end
      end

    end

  end
end

