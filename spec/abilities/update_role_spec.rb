require 'spec_helper'
require "cancan/matchers"

describe "Updating roles of employees permissions:" do
  subject                     { ability }
  let(:ability)               { Ability.new(user) }
  let(:user)                  { create(:user) }
  let(:account)               { create(:account) }
  let(:organization)          { create(:organization, account: account) }

  let(:another_employee)      { create(:employee, account: account) }
  let(:another_membership) do
    create(:membership,
      employee: another_employee,
      organization: organization)
  end

  let(:another_organization)              {  create(:organization, account: account) }
  let(:employee_of_another_organization)  {  create(:employee, account: account) }
  let(:membership_of_employee_of_another_organization) do
    create(:membership,
      employee: employee_of_another_organization,
      organization: another_organization)
  end

  let(:foreign_account)       { create(:account) }
  let(:foreign_organization)  { create(:organization, account: foreign_account) }
  let(:foreign_employee)      { create(:employee, account: foreign_account) }
  let(:foreign_membership) do
    create(:membership,
      employee: foreign_employee,
      organization: foreign_organization)
  end

  before(:each) do
    # The planner role is set on the membership, so a planner can only be
    # a planner for a certain membership/organization.
    # Simulate CanCan's current_ability method by setting the current
    # membership and employee manually here.
    user.current_membership = membership if membership
    user.current_employee = employee if employee
  end

  context "An owner" do
    let(:employee)     {  create(:employee_owner, account: account, user: user) }
    let!(:membership)  {  nil }

    it "cannot update his own role" do
      should_not be_able_to(:update_role, employee)
    end

    it "can update roles of employees of the same account" do
      # owner does not even have a membership, still he can edit employees of
      # the same account
      another_membership # create membership
      should be_able_to(:update_role, another_employee)
    end

    it "cannot update roles of employees of foreign accounts" do
      foreign_membership # create membership
      should_not be_able_to(:update_role, foreign_employee)
    end
  end

  context "A planner" do
    let(:employee) { create(:employee, account: account, user: user) }
    let!(:membership) do
      create(:membership,
        role: 'planner',
        employee: employee,
        organization: organization)
    end

    it "cannot update his own role" do
      should_not be_able_to(:update_role, employee)
    end

    it "can update roles of employees of the same organization" do
      another_membership # create membership
      should be_able_to(:update_role, another_employee)
    end

    it "cannot update roles of employees of other organizations" do
      membership_of_employee_of_another_organization # create membership
      should_not be_able_to(:update_role, employee_of_another_organization)
    end

    it "cannot update roles of employees of foreign accounts" do
      foreign_membership # create membership
      should_not be_able_to(:update_role, foreign_employee)
    end
  end

  context "An employee" do
    let(:employee) { create(:employee, account: account, user: user) }
    let!(:membership) { create(:membership, employee: employee, organization: organization) }

    it "cannot update his own role" do
      should_not be_able_to(:update_role, employee)
    end

    it "cannot update roles of employees of the same organization" do
      another_membership # create membership
      should_not be_able_to(:update_role, another_employee)
    end

    it "cannot update roles of employees of other organizations" do
      membership_of_employee_of_another_organization # create membership
      should_not be_able_to(:update_role, employee_of_another_organization)
    end

    it "cannot update roles of employees of foreign accounts" do
      foreign_membership # create membership
      should_not be_able_to(:update_role, foreign_employee)
    end
  end
end
