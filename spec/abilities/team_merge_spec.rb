require 'spec_helper'
require "cancan/matchers"

describe "TeamMerge permissions:" do
  subject { ability }
  let(:ability) { Ability.new(user) }
  let(:user) { Factory(:user) }

  let(:organization) { Factory(:organization) }
  let(:team_1) { Factory(:team, organization: organization) }
  let(:team_2) { Factory(:team, organization: organization) }

  let(:another_organization) { Factory(:organization) }
  let(:another_team_1) { Factory(:team, organization: another_organization) }
  let(:another_team_2) { Factory(:team, organization: another_organization) }

  before(:each) do
    # simulate before_filter :set_current_employee
    user.current_employee = employee if employee
  end

  context "As an owner" do
    let(:employee) { Factory(:employee_owner, organization: organization, user: user) }

    context "for own organization" do
      it "should be able to manage team merges" do
        should be_able_to(:manage, TeamMerge.new(team: team_1, other_team_id: team_2.id))
      end
    end

    context "for other organizations" do
      it "should not be able to manage team merges" do
        should_not be_able_to(:manage, TeamMerge.new(team: another_team_1, other_team_id: another_team_2.id))
        should_not be_able_to(:manage, TeamMerge.new(team: team_1, other_team_id: another_team_2.id))
      end
    end
  end

  context "As a planner" do
    let(:employee) { Factory(:employee_planner, organization: organization, user: user) }

    context "for own organization" do
      it "should be able to manage team merges" do
        should be_able_to(:manage, TeamMerge.new(team: team_1, other_team_id: team_2.id))
      end
    end

    context "for other organizations" do
      it "should not be able to manage team merges" do
        should_not be_able_to(:manage, TeamMerge.new(team: another_team_1, other_team_id: another_team_2.id))
        should_not be_able_to(:manage, TeamMerge.new(team: team_1, other_team_id: another_team_2.id))
      end
    end
  end

  context "As an employee" do
    let(:employee) { Factory(:employee, organization: organization, user: user) }

    context "for own organization" do
      it "should not be able to manage team merges" do
        should_not be_able_to(:manage, TeamMerge.new(team: team_1, other_team_id: team_2.id))
      end
    end

    context "for other organizations" do
      it "should not be able to manage team merges" do
        should_not be_able_to(:manage, TeamMerge.new(team: another_team_1, other_team_id: another_team_2.id))
        should_not be_able_to(:manage, TeamMerge.new(team: team_1, other_team_id: another_team_2.id))
      end
    end
  end

  context "As an user without employee(not possible but for the case)" do
    let(:employee) { nil }

    it "should not be able to manage team merges" do
        should_not be_able_to(:manage, TeamMerge.new(team: team_1, other_team_id: team_2.id))
    end
  end
end