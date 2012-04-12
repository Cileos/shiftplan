require 'spec_helper'
require "cancan/matchers"

describe "Invitation permissions:" do
  subject { ability }
  let(:ability) { Ability.new(user) }
  let(:user) { Factory(:user) }
  let(:organization) { Factory(:organization) }
  let(:own_employee) { Factory(:employee, organization: organization) }
  let(:another_organization) { Factory(:organization) }
  let(:another_employee) { Factory(:employee, organization: another_organization) }

  before(:each) do
    # simulate before_filter :set_current_employee
    user.current_employee = employee if employee
  end

  context "As an owner" do
    let(:employee) { Factory(:owner, organization: organization, user: user) }

    context "for other organizations" do
      it "should not be able to manage employees" do
        should_not be_able_to(:manage, Factory(:invitation, organization: another_organization, employee: another_employee))
      end
    end
  end

  context "As a planner" do
    let(:employee) { Factory(:employee, organization: organization, user: user) }

    context "for other organizations" do
      it "should not be able to manage employees" do
        should_not be_able_to(:manage, Factory(:invitation, organization: another_organization, employee: another_employee))
      end
    end
  end

  context "As an employee" do
    let(:employee) { Factory(:employee, organization: organization, user: user) }

    context "for own organization" do
      it "should not be able to manage employees" do
        should_not be_able_to(:manage, Factory(:invitation, organization: organization, employee: own_employee))
      end
    end

    context "for other organization" do
      it "should not be able to manage employees" do
        should_not be_able_to(:manage, Factory(:invitation, organization: another_organization, employee: another_employee))
      end
    end
  end

  context "As an user without employee(not possible but for the case)" do
    let(:employee) { nil }

    it "should not be able to manage employees" do
      should_not be_able_to(:manage, Factory(:invitation, organization: organization, employee: own_employee))
    end
  end
end