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

  describe "knowing mondays" do
    shared_examples "a scheduling that knows the monday" do
      it "should know the monday" do
        SchedulingFilter.new(cwyear: year, week: week).monday.should == expected_monday
      end
    end

    describe "for year 2014 and week 52" do
      it_behaves_like "a scheduling that knows the monday" do
        let(:year) { 2014 }
        let(:week) { 52 }
        let(:expected_monday) { Date.new(2014, 12, 22) }
      end
    end

    describe "for year 2015 and week 1" do
      it_behaves_like "a scheduling that knows the monday" do
        let(:year) { 2015 }
        let(:week) { 1 }
        let(:expected_monday) { Date.new(2014, 12, 29) }
      end
    end

    describe "for year 2015 and week 53" do
      it_behaves_like "a scheduling that knows the monday" do
        let(:year) { 2015 }
        let(:week) { 53 }
        let(:expected_monday) { Date.new(2015, 12, 28) }
      end
    end

    describe "for year 2016 and week 1" do
      it_behaves_like "a scheduling that knows the monday" do
        let(:year) { 2016 }
        let(:week) { 1 }
        let(:expected_monday) { Date.new(2016, 1, 4) }
      end
    end
  end

  describe "for a week and year" do
    let(:filter) { SchedulingFilter.new week: 52, cwyear: 2012 }

    it "knows the monday" do
      filter.monday.should == Date.new(2012, 12, 24) # third day of lofwyr
    end

    it "calculates the nth day of the plan" do
      filter.day_at(1).should be_a(Date)
      filter.day_at(1).should == Time.zone.parse("2012-12-24").to_date
      filter.day_at(3).should == Time.zone.parse("2012-12-26").to_date
      filter.day_at(7).should == Time.zone.parse("2012-12-30").to_date
      filter.day_at(8).should == Time.zone.parse("2012-12-31").to_date
    end

    it "depends on duration_in_days" do
      filter.should_receive(:duration_in_days).and_return(6)

      days = filter.days
      days.should have(6).items
      days.map(&:day).should == (24..29).to_a
    end

    it "lasts exactly a week" do
      filter.duration_in_days.should == 7
    end

    context "scheduled" do
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

      let(:r) { filter.records }

      it "includes all records in that week for that plan" do
        r.should include(@waiting)
        r.should include(@opening)
        r.should include(@eating1)
        r.should include(@eating2)
      end

      it "excludes records in another week" do
        drinking = create :manual_scheduling, plan: plan, year: 2012, week: 53, cwday: 2
        r.should_not include(drinking)
      end

      it "excludes records from another plan" do
        snowing = create :manual_scheduling, year: 2012, week: 52, cwday: 2
        r.should_not include(snowing)
      end
    end
  end

  describe "for exactly one day" do
    let(:filter) { SchedulingFilter.new year: 2012, month: 12, day: 23 }
    it "should know its date" do
      filter.date.should == Date.new(2012,12,23)
    end

    it "should find record on that day" do
      scheduling = create :scheduling, starts_at: filter.date
      filter.records.should include(scheduling)
    end

    it "should not find record on other day" do
      scheduling = create :scheduling, date: filter.date - 5.days
      filter.records.should_not include(scheduling)
    end

  end

  it "adds 'outside_plan_period' class to cells out of plan period"

  context "scheduling" do
    context "ranging over midnight and turn of the year" do
      # 2012-01-01: sunday
      # 2012-01-02: monday
      let(:plan) { create :plan, starts_at: '2012-01-01', ends_at: '2012-01-02' }
      let!(:scheduling) { create :manual_scheduling, year: 2011, week: 52, cwday: 7, quickie: '22-6', plan: plan }

      it "appears on evening of first day" do
        described_class.new(week: 52, cwyear: 2011).should have(1).records
      end

      it "appears on morning of second day" do
        described_class.new(week: 1, cwyear: 2012).should have(1).records
      end
    end
  end

  context "plan period" do

    context "over turn of the year" do
      let(:plan) { build :plan, starts_at: '2012-01-01', ends_at: '2012-01-02' }
      let(:filter) { described_class.new(cwyear: 2012, week: 1, plan: plan) }

      # Hardest corner case: must converts times to dates before comparing
      it { filter.should_not be_before_start_of_plan }
      it { filter.should_not be_after_end_of_plan }
    end

  end

end
