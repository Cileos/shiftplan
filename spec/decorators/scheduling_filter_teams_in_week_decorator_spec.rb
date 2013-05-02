require 'spec_helper'

describe SchedulingFilterTeamsInWeekDecorator do

  context 'found schedulings' do
    let(:plan)    { create :plan }
    let(:filter)  { SchedulingFilter.new week: 52, cwyear: 2012, plan: plan }
    let(:decorator) { described_class.new(filter) }
    let(:us)      { create :team }
    let(:others)  { create :team }
    def scheduling_today(attrs={})
      create :manual_scheduling, attrs.reverse_merge(plan: plan, year: 2012, week: 52, cwday: 1, team: us)
    end
    before do
      @created = scheduling_today
      @mate1 = scheduling_today
      @mate2 = scheduling_today
      @foe1 = scheduling_today cwday: 2
      @foe2 = scheduling_today team: others
    end

    shared_examples 'complete results' do
      it "should find the original scheduling" do
        should include(@created)
      end
      it "should find the first mate" do
        should include(@mate1)
      end
      it "should find the second mate" do
        should include(@mate2)
      end
      it "should not find scheduling on other day" do
        should_not include(@foe1)
      end
      it "should not find scheduling in other team" do
        should_not include(@foe2)
      end
    end

    context "by scheduling" do
      subject { decorator.find_schedulings(@created) }
      it_should_behave_like 'complete results'
    end

    context "by criteria" do
      subject { decorator.find_schedulings(@created.date, @created.team) }
      it_should_behave_like 'complete results'
    end

  end

end
