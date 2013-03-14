# encoding: utf-8
require 'spec_helper'

I18n.with_locale :de do

  describe WithinPlanPeriodValidator, 'for a periodized plan' do
    let(:starts_at) { Time.zone.parse('2012-12-12') }
    let(:ends_at)   { Time.zone.parse('2012-12-13') }
    def scheduling(s,e, attrs = {})
      build(:scheduling, attrs.reverse_merge(plan: plan, starts_at: s, ends_at: e))
    end

    context "with start and end time set" do
      let(:plan) { build :plan, starts_at: starts_at, ends_at: ends_at }

      it "accepts when start time and end time are within the plan period" do
        scheduling(starts_at + 8.hours, ends_at - 7.hours).should be_valid
      end

      it "accepts when start time and end time are within the plan period (almost until midnight)" do
        scheduling(ends_at - 8.hours, ends_at - 1.minute).should be_valid
      end

      it "rejects when the start time is smaller than the plan's start time" do
        scheduling = scheduling(starts_at - 16.hours, starts_at + 8.hours)
        scheduling.should_not be_valid
        scheduling.errors[:starts_at].should == ["ist kleiner als die Startzeit des Plans"]
      end

      it "rejects when start time is greater than the plan's end time" do
        scheduling = scheduling(ends_at + 1.day + 8.hours, ends_at + 1.day + 9.hours)
        scheduling.should_not be_valid
        scheduling.errors[:starts_at].should == ["ist größer als die Endzeit des Plans"]
      end

      it "rejects when the end time is smaller than the plan's start time" do
        scheduling = scheduling(starts_at + 8.hours, starts_at - 8.hours)
        scheduling.should_not be_valid
        scheduling.errors[:ends_at].should == ["ist kleiner als die Startzeit des Plans"]
      end

      it "rejects when end time is greater than the plan's end time" do
        scheduling = scheduling(starts_at + 8.hours, ends_at + 1.day + 8.hours)
        scheduling.should_not be_valid
        scheduling.errors[:ends_at].should == ["ist größer als die Endzeit des Plans"]
      end
    end

    context "with only start time set" do
      let(:plan) { build :plan, starts_at: starts_at, ends_at: nil }

      it "accepts when start time and end time are >= the plan's start time" do
        scheduling(starts_at + 1.hour, starts_at + 2.hours).should be_valid
      end

      it "rejects when the start time is smaller than the plan's start time" do
        scheduling = scheduling(starts_at - 1.hour, starts_at + 1.hour)
        scheduling.should_not be_valid
        scheduling.errors[:starts_at].should == ["ist kleiner als die Startzeit des Plans"]
      end

      it "rejects when the end time is smaller than the plan's start time" do
        scheduling = scheduling(starts_at + 1.hour, starts_at - 1.hour)
        scheduling.should_not be_valid
        scheduling.errors[:ends_at].should == ["ist kleiner als die Startzeit des Plans"]
      end
    end

    context "with only end time set" do
      let(:plan) { build :plan, starts_at: nil, ends_at: ends_at }

      it "accepts when start time and end time are <= the plan's end time" do
        scheduling(ends_at - 2.hours, ends_at - 1.hour).should be_valid
      end

      it "rejects when the start time is greater than the plan's end time" do
        scheduling = scheduling(ends_at + 1.day + 1.hour, ends_at - 1.hour)
        scheduling.should_not be_valid
        scheduling.errors[:starts_at].should == ["ist größer als die Endzeit des Plans"]
      end

      it "rejects when the end time is greater than the plan's end time" do
        scheduling = scheduling(ends_at - 1.hour, ends_at + 1.day + 1.hour)
        scheduling.should_not be_valid
        scheduling.errors[:ends_at].should == ["ist größer als die Endzeit des Plans"]
      end

      it "rejects if the next day is outside the plan period" do
        scheduling = build :manual_scheduling, quickie: '22-6', date: ends_at, plan: plan, starts_at: nil, ends_at: nil, week: nil, year: nil

        scheduling.should_not be_valid
        scheduling.errors[:base].should == ["Der nächste Tag endet nach der Endzeit des Plans."]
      end
    end
  end

end # locale :de

