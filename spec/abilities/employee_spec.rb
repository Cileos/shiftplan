require 'spec_helper'
require "cancan/matchers"


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

shared_examples "an employee who cannot manage employees" do
  it "should not be able to read other employees" do
    should_not be_able_to(:read, another_employee)
  end

  it_behaves_like "an employee who cannot create, update and destroy employees"
end

shared_examples "an employee who can manage employees" do
  context "for own accounts" do
    let(:another_employee) { build(:employee, account: nil) }

    it "should be able to manage employees without account and without organization" do
      should be_able_to(:manage, another_employee)
    end
    it "should be able to manage employees without account and an organization of the planner/owner" do
      another_employee.organization_id = organization.id
      should be_able_to(:manage, another_employee )
    end
    it "should be able to manage employees without organization and an account of the planner/owner" do
      another_employee.account_id = account.id
      should be_able_to(:manage, another_employee)
    end
    it "should be able to manage employees with an account and organization of the planner/owner" do
      another_employee.account_id = account.id
      another_employee.organization_id = organization.id
      should be_able_to(:manage, another_employee)
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

    it_behaves_like "an employee who cannot manage employees"
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
    it_behaves_like "an employee who can manage employees"
  end

  context "A planner" do
    let(:employee) { create(:employee_planner, account: account, user: user) }
    it_behaves_like "an employee who can update itself"
    it_behaves_like "an employee who can manage employees"
  end

  context "An employee" do
    let(:employee) { create(:employee, account: account, user: user) }

    it_behaves_like "an employee who can update itself"

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
    end

    context "for other accounts" do
      let(:another_employee) { build(:employee, account: other_account) }

      it_behaves_like "an employee who cannot manage employees"
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
