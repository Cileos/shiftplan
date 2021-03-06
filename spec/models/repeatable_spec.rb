require 'spec_helper'

describe Repeatable do

  let(:plan)          { create(:plan) }
  let(:employee)      { create(:employee) }
  let(:qualification) { create(:qualification) }

  let(:wednesday)     { '2012-12-12' }
  let(:thursday)      { '2012-12-13' }
  let(:friday)        { '2012-12-14' }
  let(:saturday)      { '2012-12-15' }
  let(:sunday)        { '2012-12-16' }

  let(:start_hour)    { 9 }
  let(:end_hour)      { 17 }
  let(:scheduling) do
    build_without_dates(
      plan: plan,
      employee: employee,
      qualification: qualification,
      date: '2012-12-12', # wednesday
      quickie: "#{start_hour}-#{end_hour} Putzen",
      days: [
        '2012-12-13', # thursday
        '2012-12-15'] # saturday
     )
  end

  let(:schedulings_by_starts_at) do
    Scheduling.order(:starts_at)
  end

  before(:each) do
    scheduling.save!
  end

  context "for non-overnightables" do

    let(:non_repeatable_attributes) do
      ['starts_at', 'ends_at', 'next_day', 'id', 'created_at', 'updated_at']
    end

    let(:identical_attributes) do
      scheduling.attributes.except(*non_repeatable_attributes)
    end

    it "creates a scheduling for each given repeat day" do
      Scheduling.count.should == 3
    end

    it "creates schedulings for wednesday, thursday and saturday" do
      schedulings_by_starts_at[0].starts_at.to_date.to_s.should == wednesday
      schedulings_by_starts_at[1].starts_at.to_date.to_s.should == thursday
      schedulings_by_starts_at[2].starts_at.to_date.to_s.should == saturday
    end

    it "creates repetitions for the same start and end hour as the original" do
      schedulings_by_starts_at.each do |s|
        s.start_hour.should == start_hour
        s.end_hour.should == end_hour
      end
    end

    it "creates repetitions with idential values for the repeatable attributes" do
      identical_attributes.each do |k,v|
        schedulings_by_starts_at[1][k].should == v
        schedulings_by_starts_at[2][k].should == v
      end
    end
  end

  context "for overnightables" do
    let(:start_hour)    { 22 }
    let(:end_hour)      { 6 }

    let(:schedulings) do
      schedulings_by_starts_at
    end

    it "creates no extra Schedulings" do
      Scheduling.count.should == 3
    end

    it "creates expected number of first days" do
      schedulings.count.should == 3
    end

    it "creates first days having expected date" do
      [wednesday, thursday, saturday].each_with_index do |date, i|
        schedulings[i].starts_at.to_date.to_s.should == date
      end
    end

    it "creates first days having expected start and end time" do
      schedulings.each do |day|
        day.starts_at.hour.should == 22
        day.starts_at.min.should == 0
        day.ends_at.hour.should == 6
        day.ends_at.min.should == 0
      end
    end
  end
end
