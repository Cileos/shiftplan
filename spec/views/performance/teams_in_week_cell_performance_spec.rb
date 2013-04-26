require 'spec_helper'

describe 'schedulings/lists/_teams_in_week.html.haml' do
  let(:today)  { Time.zone.parse('24.12.2012') } # a monday, for conveinance
  let(:plan) { create :plan }
  let(:n) { 10 }

  let(:schedulings) {
    (1..n).to_a.map do
      create :scheduling, plan: plan, team: create(:team), date: today, start_hour: 9, end_hour: 17
    end
  }

  let(:filter) { Scheduling.filter(cwyear: today.cwyear, week: today.cweek) }
  let(:preloaded) { filter.unsorted_records.all.map(&:decorate) }

  before :each do
    scheduling = schedulings.first
    view.stub(:nested_resources_for).with(instance_of(Scheduling)).and_return( [
      scheduling.organization.account,
      scheduling.organization,
      scheduling.plan,
      scheduling
    ] )

    view.stub(:can? => true)
  end

  it "renders cell quickly" do
    preloaded.should have(n).records
    expect do
      render partial: 'schedulings/lists/teams_in_week', locals: { schedulings: preloaded }
    end.to take_less_than(0.01)
  end
end

