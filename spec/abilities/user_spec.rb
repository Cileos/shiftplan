require 'spec_helper'
require "cancan/matchers"

shared_examples "an user who can read and update itself" do
  it "should be able to read itself" do
    should be_able_to(:read, user)
  end
  it "should be able to update itself" do
    should be_able_to(:update, user)
    should be_able_to(:update_self, user)
  end

  it "should not be able to read other users" do
    should_not be_able_to(:read, other_user)
  end
  it "should be able to update other users" do
    should_not be_able_to(:update, other_user)
    should_not be_able_to(:update_self, other_user)
  end

  it "should not be able to create users" do
    should_not be_able_to(:create, User)
  end
  it "should not be able to destroy users" do
    should_not be_able_to(:destroy, User)
  end
end

describe "User permissions:" do
  subject             {  ability }
  let(:ability)       {  Ability.new(user) }
  let(:user)          {  create(:user) }
  let(:other_user)    {  create(:user) }
  let(:account)       {  create(:account) }
  let(:organization)  {  create(:organization, account: account) }

  before(:each) do
    # simulate before_filter :set_current_employee
    user.current_employee = employee if employee
    # The planner role is set on the membership, so a planner can only be
    # a planner for a certain membership/organization.
    # Simulate CanCan's current_ability method by setting the current
    # membership manually here.
    user.current_membership = membership if membership
  end

  context "An owner" do
    let(:employee) { create(:employee_owner, account: account, user: user) }
    let(:membership) { nil }

    it_behaves_like "an user who can read and update itself"
  end

  context "A planner" do
    let(:employee) { create(:employee, account: account, user: user) }
    let(:membership) do
      create(:membership,
        role: 'planner',
        employee: employee,
        organization: organization)
    end

    it_behaves_like "an user who can read and update itself"
  end

  context "An employee" do
    let(:employee) { create(:employee, account: account, user: user) }
    let!(:membership)  {  create(:membership, employee: employee, organization: organization) }

    it_behaves_like "an user who can read and update itself"
  end

  context "A user" do
    let(:employee)   { nil }
    let(:membership) { nil }

    it_behaves_like "an user who can read and update itself"
  end
end
