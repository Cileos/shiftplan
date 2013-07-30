require 'spec_helper'
require "cancan/matchers"

describe "Task permissions" do

  shared_examples  "an employee with task permissions for foreign accounts" do
    let(:foreign_milestone) { create(:milestone, plan: create(:plan)) }
    let(:foreign_task)      { build(:task, milestone: foreign_milestone) }

    it "should not be able to CRUD tasks" do
      should_not be_able_to(:create,  foreign_task)
      should_not be_able_to(:read,    foreign_task)
      should_not be_able_to(:update,  foreign_task)
      should_not be_able_to(:destroy, foreign_task)
    end
  end

  shared_examples "an employee with task permissions without a membership" do
    let(:another_organization) { create(:organization, account: account) }
    let(:another_plan)         { create(:plan, organization: another_organization) }
    let(:another_milestone)    { create(:milestone, plan: another_plan) }
    let(:another_task)         { build(:task, milestone: another_milestone) }

    it "should not be able to CRUD tasks" do
      should_not be_able_to(:create,  another_task)
      should_not be_able_to(:read,    another_task)
      should_not be_able_to(:update,  another_task)
      should_not be_able_to(:destroy, another_task)
    end
  end

  subject                   {  ability }
  let(:ability)             {  Ability.new(user) }
  let(:user)                {  create(:user) }
  let(:account)             {  create(:account) }
  let(:organization)        {  create(:organization, account: account) }
  let(:plan)                {  create :plan, organization: organization }
  let(:milestone)           {  create :milestone, plan: plan }
  let(:task)                {  build :task, milestone: milestone }

  let(:other_account)       {  create(:account) }
  let(:other_organization)  {  create(:organization, account: other_account) }

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
      it "should be able to manage tasks" do
        should be_able_to(:manage, task)
      end
    end
    context "for other accounts" do
      it_behaves_like "an employee with task permissions for foreign accounts"
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

    context "for organizations with planner membership" do
      it "should be able to manage tasks" do
        should be_able_to(:manage, task)
      end
    end

    context "for organizations without membership" do
      it_behaves_like "an employee with task permissions without a membership"
    end

    context "for other accounts" do
      it_behaves_like "an employee with task permissions for foreign accounts"
    end
  end

  context "An employee" do
    let(:employee) { create(:employee, account: account, user: user) }
    # An "normal" employee needs a membership for an organization to do things.
    # This is different from planners or owners which do not need a membership but
    # just the role "planner" or "owner" and belong to the acccount.
    let!(:membership) { create(:membership, employee: employee, organization: organization) }

    context "for organizations with membership" do
      it "should be able to read tasks" do
        should be_able_to(:read, task)
      end
      it "should not be able to CUD tasks" do
        should_not be_able_to(:create,  task)
        should_not be_able_to(:update,  task)
        should_not be_able_to(:destroy, task)
      end
    end

    context "for organizations without membership" do
      it_behaves_like "an employee with task permissions without a membership"
    end

    context "for other accounts" do
      it_behaves_like "an employee with task permissions for foreign accounts"
    end
  end

end

