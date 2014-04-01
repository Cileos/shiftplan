require 'spec_helper'

describe 'conflicts/_scheduling.html.haml' do
  before :each do
    view.stub(
      current_plan_mode: 'employees_in_week',
      nested_show_resources_for: [],
      polymorphic_path: ''
    )
  end
  let(:scheduling) { create(:scheduling, quickie: '8-18', team_name: 'Fooling').decorate }
  subject do
    render 'conflicts/scheduling', scheduling: scheduling, provoker: provoker
    response
  end
  describe 'for scheduling in same account' do
    let(:provoker) { build_stubbed(:scheduling).decorate }
    it 'renders details' do
      provoker.stub account: scheduling.account
      should have_selector('.work_time', text: '08:00-18:00')
      should have_selector('.team_name', text: 'Fooling')
    end
  end

  describe 'for scheduling in foreign account' do
    let(:provoker) { build_stubbed(:scheduling).decorate }
    it 'renders only time period' do
      provoker.stub account: create(:account)
      should have_selector('.work_time', text: '08:00-18:00')
      should_not have_selector('.team_name')
    end
  end
end
