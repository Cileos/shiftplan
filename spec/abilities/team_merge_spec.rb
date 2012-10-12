require 'spec_helper'
require "cancan/matchers"

shared_examples "an employee who can manage team merges" do
  context "for own accounts" do
    it "can manage team merges" do
      should be_able_to(:manage, merge(team_1.id, team_2.id))
      should be_able_to(:manage, merge(team_1.id, nil))
    end
  end
  context "for other accounts" do
    it "can not create team merges" do
      should_not be_able_to(:create, merge(other_team_1.id, other_team_2.id))
    end
    it "can not read team merges" do
      should_not be_able_to(:read, merge(other_team_1.id, other_team_2.id))
    end
    it "can not update team merges" do
      should_not be_able_to(:update, merge(other_team_1.id, other_team_2.id))
    end
    it "can not destroy team merges" do
      should_not be_able_to(:destroy, merge(other_team_1.id, other_team_2.id))
    end
  end
end

shared_examples "an employee who is not able to manage team merges" do
  it "should not be able to create team merges" do
    should_not be_able_to(:create, merge(team_1.id, team_2.id))
  end
  it "should not be able to read team merges" do
    should_not be_able_to(:read, merge(team_1.id, team_2.id))
  end
  it "should not be able to update team merges" do
    should_not be_able_to(:update, merge(team_1.id, team_2.id))
  end
  it "should not be able to destroy team merges" do
    should_not be_able_to(:destroy, merge(team_1.id, team_2.id))
  end
end

describe "TeamMerge permissions:" do
  subject { ability }
  let(:ability) { Ability.new(user) }
  let(:user) { create(:user) }

  let(:account) { create(:account) }
  let(:organization) { create(:organization, account: account) }
  let(:team_1) { create(:team, organization: organization) }
  let(:team_2) { create(:team, organization: organization) }

  let(:other_account) { create(:account) }
  let(:other_organization) { create(:organization, account: other_account) }
  let(:other_team_1) { create(:team, organization: other_organization) }
  let(:other_team_2) { create(:team, organization: other_organization) }

  def merge(t_id, ot_id)
    TeamMerge.new(team_id: t_id, other_team_id: ot_id)
  end

  before(:each) do
    # simulate before_filter :set_current_employee
    user.current_employee = employee if employee
  end

  context "An owner" do
    it_behaves_like "an employee who can manage team merges" do
      let(:employee) { create(:employee_owner, account: account, user: user) }
    end
  end

  context "A planner" do
    it_behaves_like "an employee who can manage team merges" do
      let(:employee) { create(:employee_planner, account: account, user: user) }
    end
  end

  context "An employee" do
    before(:each) do
      membership
    end

    it_behaves_like "an employee who is not able to manage team merges" do
      let(:employee) { create(:employee, account: account, user: user) }
      let(:membership) { create(:membership, employee: employee, organization: organization) }
    end
  end

  context "An user without employee(not possible but for the case)" do
    it_behaves_like "an employee who is not able to manage team merges" do
      let(:employee) { nil }
    end
  end
end
