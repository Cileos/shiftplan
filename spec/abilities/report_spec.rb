require 'spec_helper'
require "cancan/matchers"

describe "Report permissions:" do
  subject { ability }
  let(:ability)                      { Ability.new(user) }
  let(:user)                         { create(:user) }
  let(:account)                      { create(:account) }
  let(:organization)                 { create(:organization, account: account) }
  let(:report_in_account)            { Report.new(account: account)}
  let(:report_in_org)                { Report.new(account: account, organization_ids: [organization.id]) }
  let(:foreign_account_report)       { Report.new(account: create(:account)) }
  let(:foreign_organization_report)  { Report.new(account: create(:account), organization_ids: [create(:organization).id]) }
  let(:report_including_foreign_organization)  do
    # Account is own account, but the organizations include a foreign
    # organization. This simulates a user manipulating the organization filter
    # by submitting organization_ids of foreign accounts.
    Report.new(account: account, organization_ids: [organization.id, create(:organization).id])
  end
  let(:report_with_foreign_organization)  do
    # Account is own account, but the organizations include a foreign
    # organization. This simulates a user manipulating the organization filter
    # by submitting organization_ids of foreign accounts.  Used to test abilites
    # of the planner. Planner can only filter by one organization at once. This
    # organization implicitely is the current organization always. As the
    # planner creates reports in organization scope only, e.g., the
    # organizations filter will not be shown there.
    Report.new(account: account, organization_ids: [create(:organization).id])
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
      should_not be_able_to(:create, report_including_foreign_organization)
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
      should_not be_able_to(:create, report_with_foreign_organization)
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
