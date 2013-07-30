require 'spec_helper'
require "cancan/matchers"

describe "Team permissions:" do
  shared_examples  "an employee with team permissions for foreign accounts" do
    let(:foreign_organization) { create(:organization) }
    let(:foreign_team)         { build(:team, organization: foreign_organization) }

    it "should not be able to CRUD teams" do
      should_not be_able_to(:create,  foreign_team)
      should_not be_able_to(:read,    foreign_team)
      should_not be_able_to(:update,  foreign_team)
      should_not be_able_to(:destroy, foreign_team)
    end
  end

  shared_examples "an employee with team permissions without a membership" do
    let(:another_organization) { create(:organization, account: account) }
    let(:another_team)         { build(:team, organization: another_organization) }

    it "should not be able to CRUD teams" do
      should_not be_able_to(:create,  another_team)
      should_not be_able_to(:read,    another_team)
      should_not be_able_to(:update,  another_team)
      should_not be_able_to(:destroy, another_team)
    end
  end

  subject { ability }
  let(:ability)       {  Ability.new(user) }
  let(:user)          {  create(:user) }
  let(:account)       {  create(:account) }
  let(:organization)  {  create(:organization, account: account) }
  let(:team)          {  build(:team, organization: organization) }


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

    context "for own accounts" do
      it "should be able to manage teams" do
        should be_able_to(:manage, team)
      end
    end
    context "for other accounts" do
      it_behaves_like "an employee with team permissions for foreign accounts"
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

    context "for organizations with planner membership" do
      it "should be able to manage teams" do
        should be_able_to(:manage, team)
      end
    end

    context "for organizations without membership" do
      it_behaves_like "an employee with team permissions without a membership"
    end

    context "for other accounts" do
      it_behaves_like "an employee with team permissions for foreign accounts"
    end
  end

  context "An employee" do
    let(:employee) { create(:employee, account: account, user: user) }
    # An "normal" employee needs a membership for an organization to do things.
    # This is different from planners or owners which do not need a membership but
    # just the role "planner" or "owner" and belong to the acccount.
    let!(:membership)  {  create(:membership, employee: employee, organization: organization) }

    context "for organizations with membership" do
      it "should not be able to CRUD teams" do
        should_not be_able_to(:create,  team)
        should_not be_able_to(:read,    team)
        should_not be_able_to(:update,  team)
        should_not be_able_to(:destroy, team)
      end
    end

    context "for organizations without membership" do
      it_behaves_like "an employee with team permissions without a membership"
    end

    context "for other accounts" do
      it_behaves_like "an employee with team permissions for foreign accounts"
    end
  end
end
