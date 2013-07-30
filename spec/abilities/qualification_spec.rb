require 'spec_helper'
require "cancan/matchers"

shared_examples  "an employee who can not create, read, update and destroy qualifications" do
  it "should not be able to create qualifications" do
    should_not be_able_to(:create, create(:qualification, account: other_account))
  end
  it "should not be able to read qualifications" do
    should_not be_able_to(:read, create(:qualification, account: other_account))
  end
  it "should not be able to update qualifications" do
    should_not be_able_to(:update, create(:qualification, account: other_account))
  end
  it "should not be able to destroy qualifications" do
    should_not be_able_to(:destroy, create(:qualification, account: other_account))
  end
end

shared_examples "an employee who can manage qualifications" do
  context "for own accounts" do
    it "should be able to manage qualifications" do
      should be_able_to(:manage, create(:qualification, account: account))
    end
  end
  context "for other accounts" do
    it_behaves_like "an employee who can not create, read, update and destroy qualifications" do
      let(:other_account) { create(:account) }
    end
  end
end

shared_examples "an employee who can not manage qualifications" do
  context "for own accounts" do
    it { should_not be_able_to(:read, build(:qualification, account: account)) }
    it { should_not be_able_to(:create, build(:qualification, account: account)) }
    it { should_not be_able_to(:update, build(:qualification, account: account)) }
    it { should_not be_able_to(:destroy, build(:qualification, account: account)) }
  end
  context "for other accounts" do
    it_behaves_like "an employee who can not create, read, update and destroy qualifications" do
      # The employee has no membership for the other_account.
      # Therefore he can not even read a qualification.
      let(:other_account) { create(:account) }
    end
  end
end

describe "Qualification permissions:" do
  subject             {  ability }
  let(:ability)       {  Ability.new(user) }
  let(:user)          {  create(:user) }
  let(:account)       {  create(:account) }
  let(:organization)  {  create(:organization, account: account) }

  before(:each) do
    # simulate before_filter :set_current_employee
    user.current_employee = employee if employee
  end

  context "An owner" do
    it_behaves_like "an employee who can manage qualifications" do
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

    it_behaves_like "an employee who can manage qualifications" do
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
    it_behaves_like "an employee who can not manage qualifications" do
      let(:employee)     { create(:employee, account: account, user: user) }
      # An "normal" employee needs a membership for an organization to do things.
      # This is different from planners or owners which do not need a membership but
      # just the role "planner" or "owner" and belong to the acccount.
      let(:organization) { create(:organization, account: account) }
      let!(:membership)   { create(:membership, employee: employee, organization: organization) }
    end
  end
end
