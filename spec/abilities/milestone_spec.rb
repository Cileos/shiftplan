require 'spec_helper'
require "cancan/matchers"

describe "Milestone permissions" do
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

  let(:new_milestone) { build :milestone, plan: plan }
  let(:milestone) { create :milestone, plan: plan }

  shared_examples 'can manage milestones' do
    it { should be_able_to(:manage, milestone )}
  end

  shared_examples 'cannot manage milestones' do
    it { should_not be_able_to(:read, milestone) }
    it { should_not be_able_to(:update, milestone) }
    it { should_not be_able_to(:create, new_milestone) }
    it { should_not be_able_to(:destroy, milestone) }
  end

  context "an owner of the same account" do
    it_behaves_like 'can manage milestones' do
      let(:employee) { create(:employee_owner, account: account, user: user) }
    end
  end

  context "a planner of the same account" do
    before(:each) do
      # The planner role is set on the membership, so a planner can only be
      # a planner for a certain membership/organization.
      # Simulate CanCan's current_ability method by setting the current
      # membership manually here.
      user.current_membership = membership
    end

    it_behaves_like 'can manage milestones' do
      let(:employee) { create(:employee, account: account, user: user) }
      let(:membership) do
        create(:membership,
          role: 'planner',
          employee: employee,
          organization: organization)
      end
    end
  end

  context "a planner of another account" do
    it_behaves_like 'cannot manage milestones' do
      let(:employee) { create(:employee, account: other_account, user: user) }
      let(:membership) do
        create(:membership,
          role: 'planner',
          employee: employee,
          organization: other_organization)
      end
    end
  end

  context 'a normal employee of the same account' do
    let(:employee) { create(:employee, account: account, user: user) }
    let!(:membership) { create(:membership, employee: employee, organization: organization) }

    it { should_not be_able_to(:update, milestone) }
    it { should_not be_able_to(:create, new_milestone) }
    it { should_not be_able_to(:destroy, milestone) }
  end

end
