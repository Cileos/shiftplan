require 'spec_helper'
require "cancan/matchers"

shared_examples "an employee that is not able to invite" do
  it "should not be able to create invitations" do
    should_not be_able_to(:create, invitation)
  end
  it "should not be able to read invitations" do
    should_not be_able_to(:read, invitation)
  end
  it "should not be able to update invitations" do
    should_not be_able_to(:update, invitation)
  end
  it "should not be able to destroy invitations" do
    should_not be_able_to(:destroy, invitation)
  end
end

shared_examples "a planner inviting employees" do
  context "for own accounts" do
    let(:invitation) { build(:invitation, organization: organization, employee: some_employee)}

    it "should be able to manage invitations" do
      should be_able_to(:manage, invitation)
    end
  end
  context "for other employees" do
    it_behaves_like "an employee that is not able to invite" do
      let(:invitation) { build(:invitation, organization: organization, employee: other_employee, inviter: employee) }
    end
  end
  context "for other organizations" do
    it_behaves_like "an employee that is not able to invite" do
      let(:invitation) { build(:invitation, organization: other_organization, employee: some_employee, inviter: employee) }
    end
  end
end

describe "Invitation permissions:" do
  subject { ability }
  let(:ability) { Ability.new(user) }
  let(:user) { create(:user) }

  let(:account) { create(:account)}
  let(:organization) { create(:organization, account: account) }
  let(:some_employee) { create(:employee, account: account) }
  let(:some_membership) { create(:membership, employee: some_employee, organization: organization) }

  let(:other_account) { create(:account) }
  let(:other_organization) { create(:organization, account: other_account) }
  let(:other_employee) { create(:employee, account: other_account) }
  let(:other_membership) { create(:membership, employee: other_employee, organization: other_organization) }

  before(:each) do
    user.current_employee = employee if employee
    # unfortunately some_membership and other_membership must be called
    # explicitely, to make sure that some_employee and other_employee really
    # belong to the organization/to the other_organization
    some_membership
    other_membership
  end

  context "An owner" do
    it_behaves_like "a planner inviting employees" do
      let(:employee) { create(:employee_owner, account: account, user: user) }
    end
  end

  context "As a planner" do
    before(:each) do
      # The planner role is set on the membership, so a planner can only be
      # a planner for a certain membership/organization.
      # Simulate CanCan's current_ability method by setting the current
      # membership manually here.
      user.current_membership = membership
    end

    it_behaves_like "a planner inviting employees" do
      let(:employee) { create(:employee, account: account, user: user) }
      let(:membership) do
        create(:membership,
          role: 'planner',
          employee: employee,
          organization: organization)
      end
    end
  end

  context "As an employee" do
    it_behaves_like "an employee that is not able to invite" do
      let(:employee) { create(:employee, account: account, user: user) }
      let!(:membership) { create(:membership, employee: employee, organization: organization) }
      let(:invitation) { build(:invitation, organization: organization, employee: some_employee)}
    end
  end

  context "As an user without employee(not possible but for the case)" do
    it_behaves_like "an employee that is not able to invite" do
      let(:employee) { nil }
      let(:invitation) { build(:invitation, organization: organization, employee: some_employee)}
    end
  end
end
