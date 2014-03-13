require 'spec_helper'
require "cancan/matchers"

describe "Report permissions:" do
  subject { ability }
  let(:ability)          { Ability.new(user) }
  let(:user)             { create(:user) }
  let(:account)          { create(:account) }
  let(:foreign_account)  { create(:account) }
  let(:organization)     { create(:organization, account: account) }

  before(:each) do
    # The planner role is set on the membership, so a planner can only be
    # a planner for a certain membership/organization.
    # Simulate CanCan's current_ability method by setting the current
    # membership and employee manually here.
    user.current_membership = membership if membership
    user.current_employee = employee if employee
  end

  context "An owner" do
    let(:employee)    {  create(:employee_owner, account: account, user: user) }
    let(:membership)  {  nil }

    it "can read reports of own accounts" do
      should be_able_to(:read_report, account)
    end

    it "can not read reports of foreign accounts" do
      should_not be_able_to(:read_report, foreign_account)
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

    it "can not read reports of own accounts" do
      should_not be_able_to(:read_report, account)
    end
  end

  context "An employee" do
    let(:employee) { create(:employee, account: account, user: user) }
    let!(:membership) { create(:membership, employee: employee, organization: organization) }

    it "can not read reports of own accounts" do
      should_not be_able_to(:read_report, account)
    end
  end
end
