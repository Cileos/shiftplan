require 'spec_helper'

describe SchedulingsController, 'Calendar performance' do
  render_views
  let(:user) { create :confirmed_user }
  let(:plan) { create :plan }
  let(:organization) { plan.organization }
  let(:account) { organization.account }
  let(:today)  { Time.zone.parse('24.12.2012') } # a monday, for conveinance

  let(:params) {{
   cwyear: today.cwyear, week: today.cweek,
   plan_id: plan, organization_id: organization, account_id: account
  }}


  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    create :employee_owner, user: user, account: account
    sign_in user
  end


  shared_examples 'quick calendar for teams in week' do
    let(:days) { 7 }
    before :each do
      employees = (1..employees_count).to_a.map do
        create(:employee, account: account).tap do |e|
          create :membership, organization: organization, employee: e
        end
      end

      teams = (1..teams_count).to_a.map do
        create :team, organization: organization
      end

      employees.each do |e|
        teams.each do |t|
          0.upto(days-1) do |d|
            1.upto(schedulings_per) do |h|
              create :scheduling, plan: plan,
                                  employee: e,
                                  team: t,
                                  date: today + d.days,
                                  start_hour: 10 + h, end_hour: 11 + h
            end
          end
        end
      end
    end # before

    it 'runs quickly', benchmark: true do
      Scheduling.should have(employees_count * teams_count * schedulings_per * days).records
      expect do
        get :teams_in_week, params
      end.to take_less_than(max)
    end
  end

  context 'a week with 70 schedulings for 10 employees and 1 team' do
    let(:employees_count) { 10 }
    let(:teams_count) { 1 }
    let(:schedulings_per) { 1 }
    let(:max) { 1.second }
    it_should_behave_like 'quick calendar for teams in week'
  end

  context 'a week with 350 schedulings for 5 employees and 5 teams' do
    let(:employees_count) { 5 }
    let(:teams_count) { 5 }
    let(:schedulings_per) { 2 }
    let(:max) { 2.seconds }
    it_should_behave_like 'quick calendar for teams in week'
  end

  context 'a week with 3500 schedulings for 10 employees and 10 teams' do
    let(:employees_count) { 10 }
    let(:teams_count) { 10 }
    let(:schedulings_per) { 5 }
    let(:max) { 8.seconds }
    it_should_behave_like 'quick calendar for teams in week'
  end
end
