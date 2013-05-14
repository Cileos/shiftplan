require 'spec_helper'

describe 'schedulings/lists/_teams_in_week.html.haml' do
  let(:today)  { Time.zone.parse('24.12.2012') } # a monday, for conveinance
  let(:plan) { create :plan }
  let(:n) { 10 }

  let!(:schedulings) {
    (1..n).to_a.map do
      create :scheduling, plan: plan, team: create(:team), date: today, start_hour: 9, end_hour: 17
    end
  }

  let(:filter) { Scheduling.filter(cwyear: today.cwyear, week: today.cweek) }
  let(:preloaded) { filter.unsorted_records.all.map(&:decorate) }

  it "renders cell with 10 items in less than 30ms (average)", benchmark: true do # this is not really quick, is it?
    preloaded.should have(n).records
    expect do
      10.times do
        render partial: 'schedulings/lists/teams_in_week', locals: { schedulings: preloaded }
      end
    end.to take_less_than(0.3)
  end
end

