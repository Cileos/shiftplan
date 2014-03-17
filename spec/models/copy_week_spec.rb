require 'spec_helper'

describe CopyWeek do
  let(:plan)          { create(:plan) }
  let(:another_plan)  { create(:plan, organization: plan.organization) }

  let(:source_year) { 2012 }
  let(:source_week) { 47 }
  let(:target_year) { 2012 }
  let(:target_week) { 49 }

  def source(attrs)
    create(:scheduling, {year: source_year, week: source_week, plan: plan}.merge(attrs))
  end

  #   November 2012
  # Su Mo Tu We Th Fr Sa
  #              1  2  3
  #  4  5  6  7  8  9 10
  # 11 12 13 14 15 16 17
  # 18 19 20 21 22 23 24 <= 47
  # 25 26 27 28 29 30
  #
  #   December 2012
  # Su Mo Tu We Th Fr Sa
  #                    1
  #  2  3  4  5  6  7  8 <= 49

  let(:copy) {
    CopyWeek.new( plan: plan,
      source_year: source_year, source_week: source_week,
      target_year: target_year, target_week: target_week
    )
  }

  let(:target_schedulings) do
    plan.filter(cwyear: target_year, week: target_week).unsorted_records
  end

  let(:source_schedulings) do
    plan.filter(cwyear: source_year, week: source_week).unsorted_records
  end

  # For year 2012 and week 49, the monday is 03.12.2012.
  let(:target_monday_schedulings) do
    target_schedulings.select do |s|
      s.starts_at.day == 3
    end
  end
  # For year 2012 and week 49, the saturday is 08.12.2012.
  let(:target_saturday_schedulings) do
    target_schedulings.select do |s|
      s.starts_at.day == 8
    end
  end
  # For year 2012 and week 49, the saturday is 09.12.2012.
  let(:target_sunday_schedulings) do
    target_schedulings.select do |s|
      s.starts_at.day == 9
    end
  end

  it "copies schedulings on monday" do
    source(cwday: 1, quickie: '8-16')
    copy.save
    target_monday_schedulings.should_not be_empty
  end

  it "remembers all copied schedulings on monday" do
    source(cwday: 1, quickie: '8-16')
    source(cwday: 2, quickie: '8-16')
    copy.save
    copy.created_schedulings.should have(2).records
    copy.created_schedulings.each do |s|
      s.should be_a(Scheduling)
    end
  end

  it "copies nightshift schedulings on weekends" do
    source(cwday: 6, quickie: '22-6')
    copy.save
    target_saturday_schedulings.should_not be_empty
    target_sunday_schedulings.should_not be_empty
    target_saturday_schedulings.first.next_day.should == target_sunday_schedulings.first
  end

  it "does not copy the comments_count of schedulings" do
    source(cwday: 1, quickie: '8-16', comments_count: 3)
    copy.save

    target_monday_schedulings.count.should == 1
    target_monday_schedulings.first.comments_count.should == 0
  end

  it "does not copy schedulings from other plans" do
    source(cwday: 1, quickie: '12-18', plan: another_plan)
    copy.save
    target_schedulings.should be_empty
  end

end
