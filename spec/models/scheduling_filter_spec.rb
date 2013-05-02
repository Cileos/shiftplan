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
    let(:filter) { SchedulingFilter.new week: 15, cwyear: 2013 }

    it "should know the monday" do
      filter.monday.should == Date.new(2013, 4, 8)
    end

    it "should calculate the nth day of the plan" do
      filter.day_at(1).should be_a(Date)
      filter.day_at(1).should == Time.zone.parse("2013-04-08").to_date
      filter.day_at(3).should == Time.zone.parse("2013-04-10").to_date
      filter.day_at(7).should == Time.zone.parse("2013-04-14").to_date
      filter.day_at(8).should == Time.zone.parse("2013-04-15").to_date
    end

    it "should depend on duration_in_days" do
      filter.should_receive(:duration_in_days).and_return(6)

      days = filter.days
      days.should have(6).items
      days.map(&:day).should == (8..13).to_a
    end

    it "should durate exactly a week" do
      filter.duration_in_days.should == 7
    end

    context "scheduled a lot" do
      let(:plan)   { create :plan }
      let(:filter) { SchedulingFilter.new week: 15, cwyear: 2013, plan: plan }
      let(:me)     { create :employee }
      let(:you)    { create :employee }

      def schedule(attrs={})
        create(:manual_scheduling, attrs.reverse_merge(plan: plan, year: 2013, week: 15, cwday: 1))
      end

      context "records" do
        subject { filter.records }

        it "includes all records in that week for that plan" do
          waiting = schedule cwday: 1, employee: you
          opening = schedule cwday: 2, employee: you
          eating1 = schedule cwday: 3, employee: you
          eating2 = schedule cwday: 3, employee: me

          should include(waiting)
          should include(opening)
          should include(eating1)
          should include(eating2)
        end

        it "does not include records in another week" do
          drinking = schedule week: 16, cwday: 2
          should_not include(drinking)
        end

        it "does not include records from another plan" do
          snowing = schedule plan: create(:plan)
          should_not include(snowing)
        end

        it "includes records starting monday at midnight" do
          early = schedule cwday: 1, quickie: '0-1'
          should include(early)
        end

        it "does not include records starting next monday at midnight" do
          early_next = schedule week: 16, cwday: 1, quickie: '0-1'
          should_not include(early_next)
        end

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

  describe "plan period" do
    let(:filter) { SchedulingFilter.new cwyear: 2012, week: 26, plan: plan }

    context "for plan without start date" do
      let(:plan) { create :plan, starts_at: nil }
      it { filter.should_not be_before_start_of_plan }
    end
    context "for plan without end date" do
      let(:plan) { create :plan, ends_at: nil }
      it { filter.should_not be_after_end_of_plan }
    end

    context "for plan with start date before filter" do
      let(:plan) { create :plan, starts_at: '2012-01-01' }
      it { filter.should_not be_before_start_of_plan }
    end
    context "for plan with start date after filter" do
      let(:plan) { create :plan, starts_at: '2012-12-21' }
      it { filter.should be_before_start_of_plan }
    end

    context "for plan with end date after filter" do
      let(:plan) { create :plan, ends_at: '2012-12-21' }
      it { filter.should_not be_after_end_of_plan }
    end
    context "for plan with end date before filter" do
      let(:plan) { create :plan, ends_at: '2012-01-01' }
      it { filter.should be_after_end_of_plan }
    end
  end

  describe '#starts_at' do
    let(:starts_at) { filter.starts_at }

    context "for week" do

      context 'in winter' do
        let(:filter) { described_class.new cwyear: 2012, week: 51 }

        it 'is at midnight' do
          starts_at.hour.should == 0
        end

        it 'has zone CET' do
          starts_at.zone.should == 'CET'
        end
      end

      context 'in summer' do
        let(:filter) { described_class.new cwyear: 2013, week: 18 }

        it 'is at midnight' do
          starts_at.hour.should == 0
        end

        it 'has zone CEST' do
          starts_at.zone.should == 'CEST'
        end
      end

    end
  end

  describe '#ends_at' do
    let(:ends_at) { filter.ends_at }

    context "for week" do

      context 'in winter' do
        let(:filter) { described_class.new cwyear: 2012, week: 51 }

        it 'is on last day' do
          ends_at.year.should == 2012
          ends_at.month.should == 12
          ends_at.day.should == 23
        end

        it 'is one second to midnight' do
          ends_at.hour.should == 23
          ends_at.min.should == 59
          ends_at.sec.should == 59
        end

        it 'has zone CET' do
          ends_at.zone.should == 'CET'
        end
      end

      context 'in summer' do
        let(:filter) { described_class.new cwyear: 2013, week: 18 }

        it 'is on last day' do
          ends_at.year.should == 2013
          ends_at.month.should == 5
          ends_at.day.should == 5
        end

        it 'is one second to midnight' do
          ends_at.hour.should == 23
          ends_at.min.should == 59
          ends_at.sec.should == 59
        end

        it 'has zone CEST' do
          ends_at.zone.should == 'CEST'
        end
      end

    end
  end

end
