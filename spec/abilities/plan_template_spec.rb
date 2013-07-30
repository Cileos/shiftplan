require 'spec_helper'
require "cancan/matchers"

describe "Plan template permissions:" do
  shared_examples  "an employee with plan_template permissions for foreign accounts" do
    let(:foreign_organization) { create(:organization) }
    let(:foreign_plan_template)         { build(:plan_template, organization: foreign_organization) }

    it "should not be able to CRUD plan_templates" do
      should_not be_able_to(:create,  foreign_plan_template)
      should_not be_able_to(:read,    foreign_plan_template)
      should_not be_able_to(:update,  foreign_plan_template)
      should_not be_able_to(:destroy, foreign_plan_template)
    end
  end

  shared_examples "an employee with plan_template permissions without a membership" do
    let(:another_organization) { create(:organization, account: account) }
    let(:another_plan_template)         { build(:plan_template, organization: another_organization) }

    it "should not be able to CRUD plan_templates" do
      should_not be_able_to(:create,  another_plan_template)
      should_not be_able_to(:read,    another_plan_template)
      should_not be_able_to(:update,  another_plan_template)
      should_not be_able_to(:destroy, another_plan_template)
    end
  end

  subject { ability }
  let(:ability)       {  Ability.new(user) }
  let(:user)          {  create(:user) }
  let(:account)       {  create(:account) }
  let(:organization)  {  create(:organization, account: account) }
  let(:plan_template)          {  build(:plan_template, organization: organization) }


  before(:each) do
    # The planner role is set on the membership, so a planner can only be
    # a planner for a certain membership/organization.
    # Simulate CanCan's current_ability method by setting the current
    # membership and employee manually here.
    user.current_membership = membership if membership
    user.current_employee = employee if employee
  end

  context "An owner" do
    let(:employee) { create(:employee_owner, account: account, user: user) }
    let(:membership) { nil }

    context "for own accounts" do
      it "should be able to manage plan_templates" do
        should be_able_to(:manage, plan_template)
      end
    end
    context "for other accounts" do
      it_behaves_like "an employee with plan_template permissions for foreign accounts"
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
      it "should be able to manage plan_templates" do
        should be_able_to(:manage, plan_template)
      end
    end

    context "for organizations without membership" do
      it_behaves_like "an employee with plan_template permissions without a membership"
    end

    context "for other accounts" do
      it_behaves_like "an employee with plan_template permissions for foreign accounts"
    end
  end

  context "An employee" do
    let(:employee) { create(:employee, account: account, user: user) }
    # An "normal" employee needs a membership for an organization to do things.
    # This is different from planners or owners which do not need a membership but
    # just the role "planner" or "owner" and belong to the acccount.
    let!(:membership)  {  create(:membership, employee: employee, organization: organization) }

    context "for organizations with membership" do
      it "should not be able to CRUD plan_templates" do
        should_not be_able_to(:create,  plan_template)
        should_not be_able_to(:read,    plan_template)
        should_not be_able_to(:update,  plan_template)
        should_not be_able_to(:destroy, plan_template)
      end
    end

    context "for organizations without membership" do
      it_behaves_like "an employee with plan_template permissions without a membership"
    end

    context "for other accounts" do
      it_behaves_like "an employee with plan_template permissions for foreign accounts"
    end
  end
end
