describe CopyWeek do
  let(:plan)          { create(:plan) }
  let(:another_plan)  { create(:plan, organization: plan.organization) }

  let(:source_year) { 2012 }
  let(:source_week) { 47 }
  let(:target_year) { 2012 }
  let(:target_week) { 49 }

  let(:target_schedulings) do
    plan.schedulings.in_cwyear(target_year).in_week(target_week)
  end
  let(:source_schedulings) do
    plan.schedulings.in_cwyear(source_year).in_week(source_week)
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

  before(:each) do
    # both schedulings in week 47, year 2012
    source_monday_scheduling = create(:scheduling, date: '2012-11-19', quickie: '8-16', plan: plan)
    # saturday to sunday
    source_overnight_scheduling = create(:scheduling, date: '2012-11-24', quickie: '22-6', plan: plan)

    # schedulings of other plans should not be copied!
    scheduling_for_another_plan = create(:scheduling, date: '2012-11-20', quickie: '12-18', plan: another_plan)

    cw = CopyWeek.new(
      plan:             plan,
      source_year:      source_year,
      source_week:      source_week,
      target_year:      target_year,
      target_week:      target_week
    )
    cw.save
  end

  it "has 3 schedulings in the source year and week to copy" do
    source_schedulings.count.should == 3
  end

  it "creates 3 schedulings in the target week and year" do
    target_schedulings.count.should == 3
  end

  it "creates 1 scheduling on monday" do
    target_monday_schedulings.count.should == 1
  end
  it "creates 1 scheduling on saturday" do
    target_saturday_schedulings.count.should == 1
  end
  it "creates 1 scheduling on sunday" do
    target_sunday_schedulings.count.should == 1
  end
  it "sets the next day for overnightables" do
    target_saturday_schedulings.first.next_day.should == target_sunday_schedulings.first
  end
end
