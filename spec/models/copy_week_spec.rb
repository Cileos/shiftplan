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
    plan.schedulings.in_cwyear(target_year).in_week(target_week)
  end

  it "copies schedulings on monday" do
    source(cwday: 1, quickie: '8-16')
    copy.save
    target_schedulings.should_not be_empty
    target_schedulings.on_weekday(1).should_not be_empty
  end

  it "copies nightshift schedulings on weekends" do
    source(cwday: 6, quickie: '22-6')
    copy.save
    target_schedulings.on_weekday(6).should_not be_empty
    target_schedulings.on_weekday(7).should_not be_empty
    target_schedulings.on_weekday(6).first.next_day.should == target_schedulings.on_weekday(7).first
  end

  it "does not copy schedulings from other plans" do
    source(cwday: 1, quickie: '12-18', plan: another_plan)
    copy.save
    target_schedulings.should be_empty
  end

end
