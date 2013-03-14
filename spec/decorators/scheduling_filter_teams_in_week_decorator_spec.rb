require 'spec_helper'

describe SchedulingFilterTeamsInWeekDecorator do
  let(:filter)  { Scheduling.filter } # overwritten in most contexts
  let(:decorator) { described_class.new(filter) }

  context "for_schedulings (index?)" do
    let(:plan)    { create :plan }
    let(:filter)  { SchedulingFilter.new week: 52, year: 2012, plan: plan }
    let(:us)      { create :team }
    let(:others)  { create :team }
    def scheduling_today(attrs={})
      create :manual_scheduling, attrs.reverse_merge(plan: plan, year: 2012, week: 52, cwday: 1, team: us)
    end
    let(:result) { decorator.find_schedulings( Date.commercial(2012,52,1), us ) }
    it "finds the schedulings with matching criteria" do
      scheduling = scheduling_today
      result.should include(scheduling)
    end
    it "should not find scheduling on other day" do
      scheduling = scheduling_today cwday: 2
      result.should_not include(scheduling)
    end
    it "should not find scheduling in other team" do
      scheduling = scheduling_today team: others
      result.should_not include(scheduling)
    end
  end

  context "cell metadata" do
    let(:day) { stub 'Date', iso8601: 'in_iso8601' }

    it "sets team-id and date" do
      team = stub 'Employee', id: 23
      decorator.cell_metadata(day,team).
        should be_hash_matching(:'team-id' => 23,
                                :date => 'in_iso8601')
    end

    it "sets team-id to 'missing' without emplyoee" do
      decorator.cell_metadata(day,nil).
        should be_hash_matching(:'team-id' => 'missing',
                                :date => 'in_iso8601')
    end
  end

end
