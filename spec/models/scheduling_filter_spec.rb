require 'spec_helper'

describe SchedulingFilter do

  it "converts stringy week to integer" do
    filter = SchedulingFilter.new(week: '23')
    filter.week.should == 23
  end

  describe "without any conditions" do

    let(:filter) { SchedulingFilter.new }

    it "should have nil range" do
      filter.range.should be_nil
    end

  end

  describe "for a week" do

    let(:filter) { SchedulingFilter.new week: 23 }

    it "should have :week range" do
      filter.range.should == :week
    end

    it "should default to current year" do
      filter.year.should == Date.today.year
    end

    it "should durate exactly a week" do
      filter.duration_in_days.should == 7
    end

  end

  describe "for a week and year" do
    let(:filter) { SchedulingFilter.new week: 52, year: 2012 }

    it "should know the first day" do
      filter.first_day.should == Date.new(2012, 12, 24) # third day of lofwyr
    end

    it "should calculate the nth day of the plan" do
      filter.day_at(1).should be_a(Date)
      filter.day_at(1).should == Time.zone.parse("2012-12-24").to_date
      filter.day_at(3).should == Time.zone.parse("2012-12-26").to_date
      filter.day_at(7).should == Time.zone.parse("2012-12-30").to_date
      filter.day_at(8).should == Time.zone.parse("2012-12-31").to_date
    end

    it "should depend on duration_in_days" do
      filter.should_receive(:duration_in_days).and_return(6)

      days = filter.days
      days.should have(6).items
      days.map(&:day).should == (24..29).to_a
    end

    it "should durate exactly a week" do
      filter.duration_in_days.should == 7
    end

    context "scheduled nothing" do
      context "index accessor" do
        it "should return empty array" do
          filter.indexed(23,42).should == []
        end
      end
    end

    context "scheduled a lot" do
      before :each do
        @me = Factory :employee
        @you = Factory :employee
        @waiting = Factory :manual_scheduling, year: 2012, week: 52, cwday: 1, employee: @you
        @opening = Factory :manual_scheduling, year: 2012, week: 52, cwday: 2, employee: @you
        @eating1 = Factory :manual_scheduling, year: 2012, week: 52, cwday: 3, employee: @you
        @eating2 = Factory :manual_scheduling, year: 2012, week: 52, cwday: 3, employee: @me
      end

      context "records" do
        let(:r) { filter.records.all }

        it "should include all records" do
          r.should include(@waiting)
          r.should include(@opening)
          r.should include(@eating1)
          r.should include(@eating2)
        end

      end

      context "index" do
        let(:i) { filter.index }

        it "should index the records by cwday" do
          i.keys.should include(@waiting.cwday)
          i.keys.should include(@opening.cwday)
          i.keys.should include(@eating1.cwday)
          i.keys.should include(@eating2.cwday)
        end

        it "should index by cwday and employee" do
          i[@waiting.cwday].keys.should have(1).record
          i[@waiting.cwday].keys.should include(@waiting.employee)
          i[@waiting.cwday][@waiting.employee].should == [@waiting]

          i[@opening.cwday][@opening.employee].should == [@opening]
        end

        it "should group to scheduling on the same cwday" do
          i[@eating1.cwday][@eating1.employee].should == [@eating1]
          i[@eating1.cwday][@eating2.employee].should == [@eating2]
          #       ^^^ grouped on 
        end
      end

      context "index accessor" do
        it "find the records" do
          filter.indexed(@eating1.cwday, @eating1.employee).should == [@eating1]
        end

        it "does not break if nothing found" do
          expect { filter.indexed(23, 42) }.not_to raise_error
        end

        it "returns empty array when nothing found" do
          filter.indexed(23, 42).should == []
        end
      end

    end

  end

end
