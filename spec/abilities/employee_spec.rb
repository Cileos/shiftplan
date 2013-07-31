require 'spec_helper'
require "cancan/matchers"

shared_examples "an employee who cannot update his own role" do
  it "should not be able to update own role" do
    should_not be_able_to(:update_role, employee)
  end
end

shared_examples "an employee who can update roles of other employees" do
  context "for own accounts" do
    let(:another_employee) { build(:employee, account: account) }
    it "should be able to update role" do
      should be_able_to(:update_role, another_employee)
    end
  end
  context "for other accounts" do
    let(:other_employee) { build(:employee, account: other_account) }
    it "should not be able to update role" do
      should_not be_able_to(:update_role, other_employee)
    end
  end
end

shared_examples "an employee who can update his profile" do
  it "should be able to update his profile" do
    should be_able_to(:update_self, employee)
  end
end

shared_examples "an employee who cannot create, update and destroy employees" do
  it "should not be able to create other employees" do
    should_not be_able_to(:create, another_employee)
  end
  it "should not be able to update other employees" do
    should_not be_able_to(:update, another_employee)
  end
  it "should not be able to destroy other employees" do
    should_not be_able_to(:destroy, another_employee)
  end
end

shared_examples "an employee who cannot read, update and create employees" do
  [:read, :update, :create].each do |action|
    it "should not be able to #{action} other employees" do
      should_not be_able_to(action, another_employee)
    end
  end

  it_behaves_like "an employee who cannot create, update and destroy employees"
end

shared_examples "an employee who can read, update, create, adopt and search employees" do |allowed_actions|
  allowed_actions ||= [:update, :create]
  context "for own accounts" do
    let(:another_employee) { build(:employee, account: nil) }

    it "should be able to adopt employees" do
      should be_able_to :adopt, Employee
    end
    it "should be able to search employees" do
      should be_able_to :search, Employee
    end

    (allowed_actions + [:read]).each do |action|
      it "should be able to #{action} employees without organization and an account of the planner/owner" do
        another_employee.account_id = account.id
        should be_able_to(action, another_employee)
      end
    end
    (allowed_actions + [:read]).each do |action|
      it "should be able to #{action} employees with an account and organization of the planner/owner" do
        another_employee.account_id = account.id
        another_employee.organization_id = organization.id
        should be_able_to(action, another_employee)
      end
    end
  end
  context "for other organizations" do
    let(:another_employee) { build(:employee, account: other_account) }

    before(:each) do
      another_employee.organization_id = create(:organization, account: other_account).id
    end

    it_behaves_like "an employee who cannot create, update and destroy employees"
  end
  context "for other accounts" do
    let(:another_employee) { build(:employee, account: other_account) }

    it_behaves_like "an employee who cannot read, update and create employees"
  end
end

describe "Employee permissions:" do
  subject { ability }
  let(:ability) { Ability.new(user) }
  let(:user) { create(:user) }
  let(:account) { create(:account) }
  let(:organization) { create(:organization, account: account) }
  let(:other_account) { create(:account) }

  before(:each) do
    user.current_employee = employee if employee
  end

  context "An owner" do
    let(:employee) { create(:employee_owner, account: account, user: user) }

    context "updating roles" do
      it_behaves_like "an employee who cannot update his own role"
      it_behaves_like "an employee who can update roles of other employees"
    end

    it_behaves_like "an employee who can read, update, create, adopt and search employees"

    # owners can not be updated by anyone except by themselves
    it "can update himself" do
      should be_able_to(:update, employee)
    end

    context "updating profiles" do
      it_behaves_like "an employee who can update his profile"
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

    let(:employee) { create(:employee, account: account, user: user) }
    let(:membership) do
      create(:membership,
        role: 'planner',
        employee: employee,
        organization: organization)
    end

    context "updating roles" do
      it_behaves_like "an employee who cannot update his own role"
    end

    context "for own organizations" do
      let(:another_employee) { create(:employee, account: account) }
      let!(:another_membership) do
        create(:membership, employee: another_employee, organization: organization)
      end

      it "can CRU employees for own organizations" do
        another_employee.organization_id = organization.id

        should be_able_to(:create, another_employee)
        should be_able_to(:read, another_employee)
        should be_able_to(:update, another_employee)
      end
    end

    it "can not update owners" do
      should_not be_able_to(:update, create(:employee_owner, account: account))
    end

    context "updating profiles" do
      it_behaves_like "an employee who can update his profile"
    end
  end

  context "An employee" do
    let(:employee) { create(:employee, account: account, user: user) }
    let!(:membership) { create(:membership, employee: employee, organization: organization) }

    context "updating roles" do
      it_behaves_like "an employee who cannot update his own role"
    end

    it "should not be able to adopt employees" do
      should_not be_able_to :adopt, Employee
    end
    it "should not be able to search employees" do
      should_not be_able_to :search, Employee
    end

    context "for own accounts" do
      it "should not be able to read employees" do
        should_not be_able_to(:read, create(:employee, account: account))
      end
      it "should not be able to create employees" do
        should_not be_able_to(:create, create(:employee, account: account))
      end
      it "should not be able to update employees" do
        should_not be_able_to(:update, create(:employee, account: account))
      end
      it "should not be able to destroy employees" do
        should_not be_able_to(:destroy, create(:employee, account: account))
      end
      it "should not be able to adopt employees" do
        should_not be_able_to(:adopt, Employee)
      end
      it "should not be able to search employees" do
        should_not be_able_to(:search, Employee)
      end
      it "should not be able to change roles" do
        should_not be_able_to(:change_role, employee)
      end
      it "should not be able to update roles of other employees" do
        should_not be_able_to(:update_role, build(:employee, account: account))
      end
    end

    context "for other accounts" do
      let(:another_employee) { build(:employee, account: other_account) }

      it_behaves_like "an employee who cannot read, update and create employees"

      it "should not be able to update roles of employees of other accounts" do
        should_not be_able_to(:update_role, build(:employee, account: other_account))
      end
    end

    context "updating profiles" do
      it_behaves_like "an employee who can update his profile"
    end
  end

  context "As an user without employee(not possible but for the case)" do
    let(:employee) { nil }

    it "should not be able to read employees" do
      should_not be_able_to(:read, create(:employee, account: account))
    end

    it "should not be able to destroy employees" do
      should_not be_able_to(:destroy, create(:employee, account: account))
    end

    it "should not be able to create employees" do
      should_not be_able_to(:create, create(:employee, account: account))
    end

    it "should not be able to update employees" do
      should_not be_able_to(:update, create(:employee, account: account))
    end
  end
end
