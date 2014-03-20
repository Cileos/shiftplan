require 'spec_helper'
require "cancan/matchers"

describe "Report permissions:" do
  subject { ability }
  let(:ability)                      { Ability.new(user) }
  let(:user)                         { create(:user) }
  let(:account)                      { create(:account) }
  let(:organization)                 { create(:organization, account: account) }
  let(:report_in_account)            { Report.new(account: account)}
  let(:report_in_org)                { Report.new(account: account, organization: organization) }
  let(:foreign_account_report)       { Report.new(account: create(:account)) }
  let(:foreign_organization_report)  { Report.new(account: create(:account), organization: create(:organization)) }

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

    it "can create reports for own accounts" do
      should be_able_to(:create, report_in_account)
    end

    it "can create reports for own organizations" do
      should be_able_to(:create, report_in_org)
    end

    it "can not create reports for foreign accounts" do
      should_not be_able_to(:create, foreign_account_report)
    end

    it "can not create reports for foreign organizations" do
      should_not be_able_to(:create, foreign_organization_report)
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

    it "can not create reports for own accounts" do
      should_not be_able_to(:create, report_in_account)
    end

    it "can create reports for own organizations" do
      should be_able_to(:create, report_in_org)
    end

    it "can not create reports for foreign accounts" do
      should_not be_able_to(:create, foreign_account_report)
    end

    it "can not create reports for foreign organizations" do
      should_not be_able_to(:create, foreign_organization_report)
    end
  end

  context "An employee" do
    let(:employee) { create(:employee, account: account, user: user) }
    let!(:membership) { create(:membership, employee: employee, organization: organization) }

    it "can not create reports for own accounts" do
      should_not be_able_to(:create, report_in_account)
    end

    it "can not create reports for own organizations" do
      should_not be_able_to(:create, report_in_org)
    end
  end
end
