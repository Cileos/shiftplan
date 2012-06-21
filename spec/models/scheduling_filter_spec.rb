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

    it "should default to no year, must be specified by controller" do
      filter.year.should be_nil
    end

    it "should durate exactly a week" do
      filter.duration_in_days.should == 7
    end

  end

  describe "for a week and year" do
    let(:filter) { SchedulingFilter.new week: 52, year: 2012 }

    it "should know the monday" do
      filter.monday.should == Date.new(2012, 12, 24) # third day of lofwyr
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

    context "scheduled a lot" do
      let(:plan)   { Factory :plan }
      let(:filter) { SchedulingFilter.new week: 52, year: 2012, plan: plan }
      let(:me)     { Factory :employee }
      let(:you)    { Factory :employee }
      before :each do
        @waiting = Factory :manual_scheduling, plan: plan, year: 2012, week: 52, cwday: 1, employee: you
        @opening = Factory :manual_scheduling, plan: plan, year: 2012, week: 52, cwday: 2, employee: you
        @eating1 = Factory :manual_scheduling, plan: plan, year: 2012, week: 52, cwday: 3, employee: you
        @eating2 = Factory :manual_scheduling, plan: plan, year: 2012, week: 52, cwday: 3, employee: me
      end

      context "records" do
        let(:r) { filter.records }

        it "should include all records in that week for that plan" do
          r.should include(@waiting)
          r.should include(@opening)
          r.should include(@eating1)
          r.should include(@eating2)
        end

        it "should not include records in another week" do
          drinking = Factory :manual_scheduling, plan: plan, year: 2012, week: 53, cwday: 2
          r.should_not include(drinking)
        end

        it "should not include records from another plan" do
          snowing = Factory :manual_scheduling, year: 2012, week: 52, cwday: 2
          r.should_not include(snowing)
        end


      end

    end

  end

end
