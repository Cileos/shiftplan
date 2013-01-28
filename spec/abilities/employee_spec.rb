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

shared_examples "an employee who can update itself" do
  it "should be able to update itself" do
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
  it "should not be able to read, update and create other employees" do
    [:read, :update, :create].each do |action|
      should_not be_able_to(action, another_employee)
    end
  end

  it_behaves_like "an employee who cannot create, update and destroy employees"
end

shared_examples "an employee who can read, update, create, adopt and search employees" do
  context "for own accounts" do
    let(:another_employee) { build(:employee, account: nil) }
    let(:allowed_actions)  { [:update, :create] }

    it "should be able to adopt employees" do
      should be_able_to :adopt, Employee
    end
    it "should be able to search employees" do
      should be_able_to :search, Employee
    end

    it "should be able to update and create employees without account and without organization" do
      allowed_actions.each do |action|
        should be_able_to(action,   another_employee)
      end
    end
    it "should be able to update and create employees without account and an organization of the planner/owner" do
      another_employee.organization_id = organization.id
      allowed_actions.each do |action|
        should be_able_to(action, another_employee )
      end
    end
    it "should be able to read, update and create employees without organization and an account of the planner/owner" do
      another_employee.account_id = account.id
      allowed_actions << :read
      allowed_actions.each do |action|
        should be_able_to(action, another_employee)
      end
    end
    it "should be able to read, update and create employees with an account and organization of the planner/owner" do
      another_employee.account_id = account.id
      another_employee.organization_id = organization.id
      allowed_actions << :read
      allowed_actions.each do |action|
        should be_able_to(action, another_employee)
      end
    end
  end
  context "for other organizations" do
    let(:another_employee) { build(:employee, account: account) }

    before(:each) do
      another_employee.organization_id = create(:organization).id
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
    # simulate before_filter :set_current_employee
    user.current_employee = employee if employee
  end

  context "An owner" do
    let(:employee) { create(:employee_owner, account: account, user: user) }

    it_behaves_like "an employee who can update itself"
    it_behaves_like "an employee who can read, update, create, adopt and search employees"
    it_behaves_like "an employee who cannot update his own role"
    it_behaves_like "an employee who can update roles of other employees"
    # owners can not be updated by anyone except by themselves
    it "can update himself" do
      should be_able_to(:update, employee)
    end
  end

  context "A planner" do
    let(:employee) { create(:employee_planner, account: account, user: user) }
    it_behaves_like "an employee who can update itself"
    it_behaves_like "an employee who can read, update, create, adopt and search employees"
    it_behaves_like "an employee who cannot update his own role"
    it_behaves_like "an employee who can update roles of other employees"
    it "can not update owners" do
      should_not be_able_to(:update, create(:employee_owner, account: account))
    end
  end

  context "An employee" do
    let(:employee) { create(:employee, account: account, user: user) }

    it_behaves_like "an employee who can update itself"

    it_behaves_like "an employee who cannot update his own role"

    it "should not be able to adopt employees" do
      should_not be_able_to :adopt, Employee
    end
    it "should not be able to search employees" do
      should_not be_able_to :search, Employee
    end

    context "for own accounts" do
      it "should be able to read employees" do
        should be_able_to(:read, create(:employee, account: account))
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
