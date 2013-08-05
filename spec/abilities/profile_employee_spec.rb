require 'spec_helper'
require "cancan/matchers"

shared_examples "a user that can only update his own profile" do
  it "can update his own profile" do
    should be_able_to(:update_profile, employee)
  end

  it "cannot update profiles of employees of same organization" do
    another_membership # create membership
    should_not be_able_to(:update_profile, another_employee)
  end

  it "cannot update profiles of employees of foreign accounts" do
    foreign_membership # create membership
    should_not be_able_to(:update_profile, foreign_employee)
  end
end

describe "Profile employee permissions:" do
  subject                     { ability }
  let(:ability)               { Ability.new(user) }
  let(:user)                  { create(:user) }
  let(:account)               { create(:account) }
  let(:organization)          { create(:organization, account: account) }

  let(:another_employee)      { create(:employee, account: account) }
  let(:another_membership) do
    create(:membership,
      employee: another_employee,
      organization: organization)
  end

  let(:foreign_account)       { create(:account) }
  let(:foreign_organization)  { create(:organization, account: foreign_account) }
  let(:foreign_employee)      { create(:employee, account: foreign_account) }
  let(:foreign_membership) do
    create(:membership,
      employee: foreign_employee,
      organization: foreign_organization)
  end

  context "An owner" do
    let(:employee) { create(:employee_owner, account: account, user: user) }
    let!(:membership) do
      create(:membership,
        employee: employee,
        organization: organization)
    end

    it_behaves_like "a user that can only update his own profile"
  end

  context "A planner" do
    let(:employee) { create(:employee, account: account, user: user) }
    let!(:membership) do
      create(:membership,
        role: 'planner',
        employee: employee,
        organization: organization)
    end

    it_behaves_like "a user that can only update his own profile"
  end

  context "An employee" do
    let(:employee) { create(:employee, account: account, user: user) }
    let!(:membership) { create(:membership, employee: employee, organization: organization) }

    it_behaves_like "a user that can only update his own profile"
  end
end
