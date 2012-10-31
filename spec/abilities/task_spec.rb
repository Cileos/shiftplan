require 'spec_helper'
require "cancan/matchers"

describe "Task permissions" do
  subject { ability }
  let(:ability) { Ability.new(user) }
  let(:user) { create(:user) }

  let(:account) { create(:account) }
  let(:organization) { create(:organization, account: account) }

  let(:other_account) { create(:account) }
  let(:other_organization) { create(:organization, account: other_account) }

  let(:plan) { create :plan, organization: organization }

  before(:each) do
    # simulate before_filter :set_current_employee
    user.current_employee = employee if employee
  end
  let(:milestone) { create :milestone, plan: plan }

  let(:new_task) { build :task, milestone: milestone }
  let(:task) { create :task, milestone: milestone }

  shared_examples 'can manage tasks' do
    it { should be_able_to(:manage, task )}
  end

  shared_examples 'cannot manage tasks' do
    it { should_not be_able_to(:read, task) }
    it { should_not be_able_to(:update, task) }
    it { should_not be_able_to(:create, new_task) }
    it { should_not be_able_to(:destroy, task) }
  end

  context "a planner of the same account" do
    it_behaves_like 'can manage tasks' do
      let(:employee) { create(:employee_planner, account: account, user: user) }
    end
  end

  context "a planner of another account" do
    it_behaves_like 'cannot manage tasks' do
      let(:employee) { create(:employee_planner, account: other_account, user: user) }
    end
  end

  context 'a normal employee of the same account' do
    it_behaves_like 'cannot manage tasks' do
      let(:employee) { create(:employee, account: account, user: user) }
    end

    it "may mark tasks as done?"
  end

end

