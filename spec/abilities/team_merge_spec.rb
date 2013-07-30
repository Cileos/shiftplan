require 'spec_helper'
require "cancan/matchers"

describe "TeamMerge permissions:" do

  shared_examples  "an employee with team merge permissions for foreign accounts" do
    let(:foreign_organization)  {  create(:organization) }
    let(:foreign_team_1)        {  create(:team, organization: foreign_organization) }
    let(:foreign_team_2)        {  create(:team, organization: foreign_organization) }

    it "should not be able to CRUD team merges" do
      should_not be_able_to(:create, merge(foreign_team_1.id, team_2.id, team_1.id))
      should_not be_able_to(:create, merge(team_1.id, foreign_team_2.id, team_2.id))
      should_not be_able_to(:create, merge(team_1.id, team_2.id, foreign_team_1.id))

      should_not be_able_to(:read, merge(foreign_team_1.id, team_2.id, team_1.id))
      should_not be_able_to(:read, merge(team_1.id, foreign_team_2.id, team_2.id))
      should_not be_able_to(:read, merge(team_1.id, team_2.id, foreign_team_1.id))

      should_not be_able_to(:update, merge(foreign_team_1.id, team_2.id, team_1.id))
      should_not be_able_to(:update, merge(team_1.id, foreign_team_2.id, team_2.id))
      should_not be_able_to(:update, merge(team_1.id, team_2.id, foreign_team_1.id))

      should_not be_able_to(:destroy, merge(foreign_team_1.id, team_2.id, team_1.id))
      should_not be_able_to(:destroy, merge(team_1.id, foreign_team_2.id, team_2.id))
      should_not be_able_to(:destroy, merge(team_1.id, team_2.id, foreign_team_1.id))
    end
  end

  shared_examples "an employee with team merge permissions without a membership" do
    let(:another_organization)  {  create(:organization, account: account) }
    let(:another_team_1)        {  create(:team, organization: another_organization) }
    let(:another_team_2)        {  create(:team, organization: another_organization) }

    it "should not be able to CRUD team merges" do
      should_not be_able_to(:create, merge(another_team_1.id, team_2.id, team_1.id))
      should_not be_able_to(:create, merge(team_1.id, another_team_2.id, team_2.id))
      should_not be_able_to(:create, merge(team_1.id, team_2.id, another_team_1.id))

      should_not be_able_to(:read, merge(another_team_1.id, team_2.id, team_1.id))
      should_not be_able_to(:read, merge(team_1.id, another_team_2.id, team_2.id))
      should_not be_able_to(:read, merge(team_1.id, team_2.id, another_team_1.id))

      should_not be_able_to(:update, merge(another_team_1.id, team_2.id, team_1.id))
      should_not be_able_to(:update, merge(team_1.id, another_team_2.id, team_2.id))
      should_not be_able_to(:update, merge(team_1.id, team_2.id, another_team_1.id))

      should_not be_able_to(:destroy, merge(another_team_1.id, team_2.id, team_1.id))
      should_not be_able_to(:destroy, merge(team_1.id, another_team_2.id, team_2.id))
      should_not be_able_to(:destroy, merge(team_1.id, team_2.id, another_team_1.id))
    end
  end

  subject { ability }
  let(:ability) { Ability.new(user) }
  let(:user) { create(:user) }

  let(:account) { create(:account) }
  let(:organization) { create(:organization, account: account) }
  let(:team_1) { create(:team, organization: organization) }
  let(:team_2) { create(:team, organization: organization) }

  def merge(t_id, ot_id, nt_id)
    TeamMerge.new(team_id: t_id, other_team_id: ot_id, new_team_id: nt_id)
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
    let(:employee) { create(:employee_owner, account: account, user: user) }
    let(:membership) { nil }

    context "for own accounts" do
      it "should be able to manage team merges" do
        should be_able_to(:manage, merge(team_1.id, team_2.id, team_1.id))
      end
    end
    context "for other accounts" do
      it_behaves_like "an employee with team merge permissions for foreign accounts"
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
      it "should be able to manage team merges" do
        should be_able_to(:manage, merge(team_1.id, team_2.id, team_1.id))
      end
    end

    context "for organizations without membership" do
      it_behaves_like "an employee with team merge permissions without a membership"
    end

    context "for other accounts" do
      it_behaves_like "an employee with team merge permissions for foreign accounts"
    end
  end

  context "An employee" do
    let(:employee) { create(:employee, account: account, user: user) }
    # An "normal" employee needs a membership for an organization to do things.
    # This is different from planners or owners which do not need a membership but
    # just the role "planner" or "owner" and belong to the acccount.
    let!(:membership)  {  create(:membership, employee: employee, organization: organization) }

    context "for organizations with membership" do
      it "should not be able to CRUD team merges" do
        should_not be_able_to(:create, merge(team_1.id, team_2.id, team_1.id))
        should_not be_able_to(:read, merge(team_1.id, team_2.id, team_1.id))
        should_not be_able_to(:update, merge(team_1.id, team_2.id, team_1.id))
        should_not be_able_to(:destroy, merge(team_1.id, team_2.id, team_1.id))
      end
    end

    context "for organizations without membership" do
      it_behaves_like "an employee with team merge permissions without a membership"
    end

    context "for other accounts" do
      it_behaves_like "an employee with team merge permissions for foreign accounts"
    end
  end
end
