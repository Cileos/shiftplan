require 'spec_helper'
require "cancan/matchers"


shared_examples "an employee who can edit itself" do
  it "should be able to read itself" do
    should be_able_to(:read, employee)
  end
  it "should be able to update itself" do
    should be_able_to(:update, employee)
  end
end

shared_examples "an employee who cannot manage employees" do
  it "should not be able to create other employees" do
    should_not be_able_to(:create, create(:employee, account: other_account))
  end
  it "should not be able to read other employees" do
    should_not be_able_to(:read, create(:employee, account: other_account))
  end
  it "should not be able to update other employees" do
    should_not be_able_to(:update, create(:employee, account: other_account))
  end
  it "should not be able to destroy other employees" do
    should_not be_able_to(:destroy, create(:employee, account: other_account))
  end
end

shared_examples "an employee who can manage employees" do
  context "for own accounts" do
    it "should be able to manage employees" do
      should be_able_to(:manage, create(:employee, account: account))
    end
  end
  context "for other accounts" do
    it_behaves_like "an employee who cannot manage employees"
  end
end

describe "Employee permissions:" do
  subject { ability }
  let(:ability) { Ability.new(user) }
  let(:user) { create(:user) }
  let(:account) { create(:account) }
  let(:other_account) { create(:account) }

  before(:each) do
    # simulate before_filter :set_current_employee
    user.current_employee = employee if employee
  end

  context "An owner" do
    let(:employee) { create(:employee_owner, account: account, user: user) }

    it_behaves_like "an employee who can edit itself"
    it_behaves_like "an employee who can manage employees"
  end

  context "A planner" do
    let(:employee) { create(:employee_planner, account: account, user: user) }
    it_behaves_like "an employee who can edit itself"
    it_behaves_like "an employee who can manage employees"
  end

  context "An employee" do
    let(:employee) { create(:employee, account: account, user: user) }

    it_behaves_like "an employee who can edit itself"

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
