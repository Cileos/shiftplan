require 'spec_helper'

describe OvernightableJoiner do
  let(:starts_at) { Time.zone.parse '2014-09-24 16:00' }
  let(:ends_at)   { Time.zone.parse '2014-09-25 08:00' }
  before :each do
    Scheduling.connection.insert_fixture(
      { plan_id: plan.id,
        starts_at: ends_at.beginning_of_day,
        ends_at: ends_at,
        id: 25 },
      'schedulings'
    )
    Scheduling.connection.insert_fixture(
      { plan_id: plan.id,
        starts_at: starts_at,
        ends_at: starts_at.end_of_day,
        id: 24,
        next_day_id: 25 },
      'schedulings'
    )
  end
  let(:first) { Scheduling.order(:id).first }
  let(:last)  { Scheduling.order(:id).last }

  it 'combines first and next day to one Scheduling spanning all the time' do
    Scheduling.should have(2).records
    first.next_day.should == last
    last.previous_day.should == first
    pending "just preconditions"
  end
  it 'keeps comments'
  it 'keeps employee'
  it 'keeps team'
  it 'keeps plan'

  let(:plan) { create :plan }
end
