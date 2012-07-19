require 'spec_helper'
require "cancan/matchers"

describe "TeamMerge permissions:" do
  subject { ability }
  let(:ability) { Ability.new(user) }
  let(:user) { create(:user) }

  let(:organization) { create(:organization) }
  let(:team_1) { create(:team, organization: organization) }
  let(:team_2) { create(:team, organization: organization) }

  let(:another_organization) { create(:organization) }
  let(:another_team_1) { create(:team, organization: another_organization) }
  let(:another_team_2) { create(:team, organization: another_organization) }

  def merge(t, ot)
    TeamMerge.new(team_id: t.id, other_team_id: ot.id)
  end

  before(:each) do
    # simulate before_filter :set_current_employee
    user.current_employee = employee if employee
  end

  context "As an owner" do
    let(:employee) { create(:employee_owner, organization: organization, user: user) }

    context "for own organization" do
      it "should be able to manage team merges" do
        should be_able_to(:manage, merge(team_1, team_2))
      end
    end

    context "for other organizations" do
      it "should not be able to manage team merges" do
        should_not be_able_to(:manage, merge(another_team_1, another_team_2))
        should_not be_able_to(:manage, merge(team_1, another_team_2))
      end
    end
  end

  context "As a planner" do
    let(:employee) { create(:employee_planner, organization: organization, user: user) }

    context "for own organization" do
      it "should be able to manage team merges" do
        should be_able_to(:manage, merge(team_1, team_2))
      end
    end

    context "for other organizations" do
      it "should not be able to manage team merges" do
        should_not be_able_to(:manage, merge(another_team_1, another_team_2))
        should_not be_able_to(:manage, merge(team_1, another_team_2))
      end
    end
  end

  context "As an employee" do
    let(:employee) { create(:employee, organization: organization, user: user) }

    context "for own organization" do
      it "should not be able to manage team merges" do
        should_not be_able_to(:manage, merge(team_1, team_2))
      end
    end

    context "for other organizations" do
      it "should not be able to manage team merges" do
        should_not be_able_to(:manage, merge(another_team_1, another_team_2))
        should_not be_able_to(:manage, merge(team_1, another_team_2))
      end
    end
  end

  context "As an user without employee(not possible but for the case)" do
    let(:employee) { nil }

    it "should not be able to manage team merges" do
      should_not be_able_to(:manage, merge(team_1, team_2))
    end
  end
end
