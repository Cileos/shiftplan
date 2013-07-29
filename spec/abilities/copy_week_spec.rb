require 'spec_helper'
require "cancan/matchers"

shared_examples "a planner who copies weeks for own accounts" do
  it "should be able to manage copy weeks" do
    should be_able_to(:manage, copy_week)
  end
end

shared_examples "a planner who can not copy weeks for other accounts" do
  it "should not be able to create copy weeks" do
    should_not be_able_to(:create, other_copy_week)
  end
  it "should not be able to read copy weeks" do
    should_not be_able_to(:read, other_copy_week)
  end
  it "should not be able to update copy weeks" do
    should_not be_able_to(:update, other_copy_week)
  end
  it "should not be able to destroy copy weeks" do
    should_not be_able_to(:destroy, other_copy_week)
  end
end

shared_examples "an employee who can not copy weeks" do
  it "should not be able to create copy weeks" do
    should_not be_able_to(:create, copy_week)
  end
  it "should not be able to read copy weeks" do
    should_not be_able_to(:read, copy_week)
  end
  it "should not be able to update copy weeks" do
    should_not be_able_to(:update, copy_week)
  end
  it "should not be able to destroy copy weeks" do
    should_not be_able_to(:destroy, copy_week)
  end
end

shared_examples "a planner that copies weeks" do
  it_behaves_like "a planner who copies weeks for own accounts"
  it_behaves_like "a planner who can not copy weeks for other accounts"
end

describe "CopyWeek permissions:" do
  subject { ability }
  let(:ability) { Ability.new(user) }
  let(:user) { create(:user) }

  let(:account) { create(:account) }
  let(:organization) { create(:organization, account: account) }
  let(:plan) { create(:plan, organization: organization)}
  let(:copy_week) { CopyWeek.new(plan: plan)}

  let(:other_account) { create(:account) }
  let(:other_organization) { create(:organization, account: other_account) }
  let(:other_plan) { create(:plan, organization: other_organization)}
  let(:other_copy_week) { CopyWeek.new(plan: other_plan) }

  before(:each) do
    # simulate before_filter :set_current_employee
    user.current_employee = employee if employee
  end

  context "An owner" do
    it_behaves_like "a planner that copies weeks" do
      let(:employee) { create(:employee_owner, account: account, user: user) }
    end
  end

  context "A planner" do
    before(:each) do
      # The planner role is set on the membership, so a planner can only be
      # a planner for a certain membership/organization.
      # Simulate CanCan's current_ability method by setting the current
      # membership manually here.
      user.current_membership = membership
    end

    it_behaves_like "a planner that copies weeks" do
      let(:employee) { create(:employee, account: account, user: user) }
      let(:membership) do
        create(:membership,
          role: 'planner',
          employee: employee,
          organization: organization)
      end
    end
  end

  context "An employee" do
    it_behaves_like "an employee who can not copy weeks" do
      let(:employee)   { create(:employee, account: account, user: user) }
      # An "normal" employee needs a membership for an organization to do things.
      # This is different from planners or owners which do not need a membership but
      # just the role "planner" or "owner" and belong to the acccount.
      let!(:membership) { create(:membership, employee: employee, organization: organization) }
    end
  end
end
