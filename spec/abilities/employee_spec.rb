require 'spec_helper'
require "cancan/matchers"

shared_examples "an employee who can adopt and search employees" do
  it "can adopt employees" do
    should be_able_to :adopt, Employee
  end

  it "can search employees" do
    should be_able_to :search, Employee
  end
end

describe "Employee permissions:" do
  subject                     {  ability }
  let(:ability)               {  Ability.new(user) }
  let(:user)                  {  create(:user) }
  let(:account)               {  create(:account) }
  let(:organization)          {  create(:organization, account: account) }

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

  let(:foreign_account)       {  create(:account) }
  let(:foreign_organization)  {  create(:organization, account: foreign_account) }
  let(:foreign_employee)      {  create(:employee, account: foreign_account) }

  before(:each) do
    # The planner role is set on the membership, so a planner can only be
    # a planner for a certain membership/organization.
    # Simulate CanCan's current_ability method by setting the current
    # membership manually here.
    user.current_membership = membership if membership
    user.current_employee = employee if employee
  end

  context "An owner" do
    let(:employee)    {  create(:employee_owner, account: account, user: user) }
    let(:membership)  {  nil }

    it_behaves_like "an employee who can adopt and search employees"

    it "can read employees of own accounts" do
      another_membership # create membership

      should be_able_to :read, another_employee
    end

    it "cannot read employees of foreign accounts" do
      should_not be_able_to :read, foreign_employee
    end

    it "can create and update employees for organizations of own account" do
      e = build(:employee, account: account)
      # organization_id is a virtual attribute of employee and is used to
      # create the membership for the current organization after create of the
      # employee. So the following line makes sure that memberships for orgs
      # of other account can not be created.
      e.organization_id = organization.id

      should be_able_to :create, e
      should be_able_to :update, e
    end

    it "cannot create and update employees for foreign accounts" do
      e = build(:employee, account: foreign_account)
      e.organization_id = organization.id

      should_not be_able_to :create, e
      should_not be_able_to :update, e
    end

    it "cannot create and update employees for foreign organizations" do
      e = build(:employee, account: account)
      e.organization_id = foreign_organization.id

      should_not be_able_to :create, e
      should_not be_able_to :update, e
    end

    # owners can not be updated by anyone except by themselves
    it "can update himself" do
      employee.organization_id = organization.id

      should be_able_to(:update, employee)
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

    it_behaves_like "an employee who can adopt and search employees"

    it "can read employees of own organizations" do
      another_membership # create membership

      should be_able_to :read, another_employee
    end

    it "cannot read employees of other organizations" do
      membership_of_employee_of_another_organization # create membership

      should_not be_able_to :read, employee_of_another_organization
    end

    it "cannot read employees of foreign accounts" do
      should_not be_able_to :read, foreign_employee
    end

    it "can create and update employees for own organizations and own account" do
      e = build(:employee, account: account)
      # organization_id is a virtual attribute of employee and is used to
      # create the membership for the current organization after create of the
      # employee. So the following line makes sure that memberships for orgs
      # of other account can not be created.
      e.organization_id = organization.id

      should be_able_to :create, e
      should be_able_to :update, e
    end

    it "cannot create and update employees for foreign accounts" do
      e = build(:employee, account: foreign_account)
      e.organization_id = organization.id

      should_not be_able_to :create, e
      should_not be_able_to :update, e
    end

    it "cannot create and update employees for foreign organizations" do
      e = build(:employee, account: account)
      e.organization_id = foreign_organization.id

      should_not be_able_to :create, e
      should_not be_able_to :update, e
    end

    it "can update himself" do
      employee.organization_id = organization.id

      should be_able_to(:update, employee)
    end

    it "cannot create and update owners" do
      owner = create(:employee_owner, account: account)
      owner.organization_id = organization.id

      should_not be_able_to(:update, owner)
      should_not be_able_to(:create, owner)
    end
  end

  context "An employee" do
    let(:employee) { create(:employee, account: account, user: user) }
    let!(:membership) { create(:membership, employee: employee, organization: organization) }

    it "should not be able to adopt employees" do
      should_not be_able_to :adopt, Employee
    end
    it "should not be able to search employees" do
      should_not be_able_to :search, Employee
    end

    it "cannot read employees of own organizations" do
      another_membership # create membership

      should_not be_able_to :read, another_employee
    end

    it "cannot read employees of other organizations" do
      membership_of_employee_of_another_organization # create membership

      should_not be_able_to :read, employee_of_another_organization
    end

    it "cannot read employees of foreign accounts" do
      should_not be_able_to :read, foreign_employee
    end

    it "cannot create and update employees for own organizations and own account" do
      e = build(:employee, account: account)
      # organization_id is a virtual attribute of employee and is used to
      # create the membership for the current organization after create of the
      # employee. So the following line makes sure that memberships for orgs
      # of other account can not be created.
      e.organization_id = organization.id

      should_not be_able_to :create, e
      should_not be_able_to :update, e
    end

    it "cannot create and update employees for foreign accounts" do
      e = build(:employee, account: foreign_account)
      e.organization_id = organization.id

      should_not be_able_to :create, e
      should_not be_able_to :update, e
    end

    it "cannot create and update employees for foreign organizations" do
      e = build(:employee, account: account)
      e.organization_id = foreign_organization.id

      should_not be_able_to :create, e
      should_not be_able_to :update, e
    end

    it "cannot update himself" do
      should_not be_able_to(:update, employee)
    end

    it "cannot create and update owners" do
      should_not be_able_to(:update, create(:employee_owner, account: account))
      should_not be_able_to(:create, create(:employee_owner, account: account))
    end
  end
end
