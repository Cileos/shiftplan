require 'spec_helper'
require "cancan/matchers"

describe "CopyWeek permissions:" do
  subject { ability }
  let(:ability) { Ability.new(user) }
  let(:user) { create(:user) }

  let(:organization) { create(:organization) }
  let(:plan) { create(:plan, organization: organization) }

  let(:another_organization) { create(:organization) }
  let(:another_plan) { create(:plan, organization: another_organization) }

  before(:each) do
    # simulate before_filter :set_current_employee
    user.current_employee = employee if employee
  end

  context "As an owner" do
    let(:employee) { create(:employee_owner, organization: organization, user: user) }

    context "for own organization" do
      it "should be able copy weeks" do
        should be_able_to(:manage, CopyWeek.new(plan: plan))
      end
    end

    context "for other organizations" do
      it "should not be able copy weeks" do
        should_not be_able_to(:manage, CopyWeek.new(plan: another_plan))
      end
    end
  end

  context "As a planner" do
    let(:employee) { create(:employee_planner, organization: organization, user: user) }

    context "for own organization" do
      it "should be able copy weeks" do
        should be_able_to(:manage, CopyWeek.new(plan: plan))
      end
    end

    context "for other organizations" do
      it "should not be able copy weeks" do
        should_not be_able_to(:manage, CopyWeek.new(plan: another_plan))
      end
    end
  end

  context "As an employee" do
    let(:employee) { create(:employee, organization: organization, user: user) }

    context "for own organization" do
      it "should not be able copy weeks" do
        should_not be_able_to(:manage, CopyWeek.new(plan: plan))
      end
    end

    context "for other organizations" do
      it "should not be able copy weeks" do
        should_not be_able_to(:manage, CopyWeek.new(plan: another_plan))
      end
    end
  end

  context "As an user without employee(not possible but for the case)" do
    let(:employee) { nil }

    context "for own organization" do
      it "should not be able copy weeks" do
        should_not be_able_to(:manage, CopyWeek.new(plan: plan))
      end
    end

    context "for other organizations" do
      it "should not be able copy weeks" do
        should_not be_able_to(:manage, CopyWeek.new(plan: another_plan))
      end
    end
  end
end
