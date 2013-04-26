require 'spec_helper'

describe 'addition' do
  it "runs quickly" do
    expect do
      8000.times { 1+2 }
    end.to take_less_than(0.002).seconds
  end
end

describe SchedulingsController, 'Calendar performance' do

  context 'a week with 10 employees, 10 teams, 5 schedulings per cell every day, 10 comments on each' do
    render_views

    let(:user) { create :confirmed_user }
    let(:plan) { create :plan }
    let(:organization) { plan.organization }
    let(:account) { organization.account }
    let(:today)  { Time.zone.parse('24.12.2012') } # a monday, for conveinance

    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user

      employees = (1..10).to_a.map do
        create(:employee, account: account).tap do |e|
          create :membership, organization: organization, employee: e
        end
      end

      teams = (1..10).to_a.map do
        create :team, organization: organization
      end

      employees.each do |e|
        teams.each do |t|
          0.upto(6) do |d|
            1.upto(1) do |h|
              s = create :scheduling, plan: plan, employee: e, team: t, date: today + d.days, start_hour: 10 + h, end_hour: 11 + h

              create :comment, employee: e, commentable: s
            end
          end
        end
      end

      create :employee_owner, user: user, account: account
    end

    let(:params) {{
     cwyear: today.cwyear, week: today.cweek,
     plan_id: plan, organization_id: organization, account_id: account
    }}

    xit 'renders all the schedulings' do
      get :teams_in_week, params
      File.open('tmp/calendar.html', 'w') { |f| f.write response.body }
      binding.pry
    end

    it 'runs quickly', benchmark: true do
      expect do
        10.times { get :teams_in_week, params }
      end.to take_less_than(5.seconds)
    end
  end
end
