require 'spec_helper'
require "cancan/matchers"

describe "Scheduling permissions:" do
  shared_examples  "an employee with scheduling permissions for foreign accounts" do
    let(:foreign_plan)        {  create(:plan, organization: create(:organization)) }
    let(:foreign_scheduling)  {  build(:scheduling, plan: foreign_plan) }

    it "should not be able to CRUD schedulings" do
      should_not be_able_to(:create, foreign_scheduling)
      should_not be_able_to(:read, foreign_scheduling)
      should_not be_able_to(:update, foreign_scheduling)
      should_not be_able_to(:destroy, foreign_scheduling)
    end
  end

  shared_examples "an employee with scheduling permissions without a membership" do
    let(:another_organization)  {  create(:organization, account: account) }
    let(:another_plan)          {  create(:plan, organization: another_organization) }
    let(:another_scheduling)    {  build(:scheduling, plan: another_plan) }

    it "should not be able to CRUD schedulings" do
      should_not be_able_to(:create, another_scheduling)
      should_not be_able_to(:read, another_scheduling)
      should_not be_able_to(:update, another_scheduling)
      should_not be_able_to(:destroy, another_scheduling)
    end
  end

  subject             {  ability }
  let(:ability)       {  Ability.new(user) }
  let(:user)          {  create(:user) }
  let(:account)       {  create(:account) }
  let(:organization)  {  create(:organization, account: account) }
  let(:plan)          {  create(:plan, organization: organization) }


  before(:each) do
    # simulate before_filter :set_current_employee
    user.current_employee = employee if employee
    # The planner role is set on the membership, so a planner can only be
    # a planner for a certain membership/organization.
    # Simulate CanCan's current_ability method by setting the current
    # membership manually here.
    user.current_membership = membership if membership
  end

  context "An owner" do
    let(:employee) { create(:employee_owner, account: account, user: user) }
    # an owner does not need a membership for an organization to do things
    let(:membership) { nil }

    context "for own accounts" do
      it "should be able to manage schedulings" do
        should be_able_to(:manage, create(:scheduling, plan: plan))
      end
    end
    context "for other accounts" do
      it_behaves_like "an employee with scheduling permissions for foreign accounts"
    end
  end

  context "A planner" do
    let(:employee) { create(:employee, account: account, user: user) }
    let(:membership) do
      create(:membership,
        role: 'planner',
        employee: employee,
        organization: organization)
    end

    context "for organizations with membership" do
      it "should be able to manage schedulings" do
        should be_able_to(:manage, create(:scheduling, plan: plan))
      end
    end

    context "for organizations without membership" do
      it_behaves_like "an employee with scheduling permissions without a membership"
    end

    context "for other accounts" do
      it_behaves_like "an employee with scheduling permissions for foreign accounts"
    end
  end

  context "An employee" do
    let(:employee) { create(:employee, account: account, user: user) }
    # An "normal" employee needs a membership for an organization to do things.
    # This is different from planners or owners which do not need a membership but
    # just the role "planner" or "owner" and belong to the acccount.
    let!(:membership) { create(:membership, employee: employee, organization: organization) }
    let(:scheduling)  { build(:scheduling, plan: plan) }

    context "for organizations with membership" do
      it "should be able to read schedulings" do
        should be_able_to(:read, scheduling)
      end
      it "should not be able to CUD schedulings" do
        should_not be_able_to(:create, scheduling)
        should_not be_able_to(:update, scheduling)
        should_not be_able_to(:destroy, scheduling)
      end
    end

    context "for organizations without membership" do
      it_behaves_like "an employee with scheduling permissions without a membership"
    end

    context "for other accounts" do
      it_behaves_like "an employee with scheduling permissions for foreign accounts"
    end
  end
end
