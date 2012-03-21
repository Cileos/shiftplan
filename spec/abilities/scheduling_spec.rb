require 'spec_helper'
require "cancan/matchers"

describe "Scheduling permissions:" do
  subject { ability }
  let(:ability) { Ability.new(user) }
  let(:user) { Factory(:user) }
  let(:organization) { Factory(:organization) }
  let(:plan) { Factory(:plan, organization: organization) }
  let(:another_organization) { Factory(:organization) }
  let(:another_plan) { Factory(:plan, organization: another_organization) }

  before(:each) do
    # simulate before_filter :set_current_employee
    user.current_employee = employee if employee
  end

  context "As an owner" do
    let(:employee) { Factory(:owner, organization: organization, user: user) }

    context "for other organizations" do
      it "should not be able to read schedulings" do
        should_not be_able_to(:read, Factory(:scheduling, plan: another_plan))
      end

      it "should not be able to update schedulings" do
        should_not be_able_to(:update, Factory(:scheduling, plan: another_plan))
      end

      it "should not be able to create schedulings" do
        should_not be_able_to(:create, Factory.build(:scheduling, plan: another_plan))
      end

      it "should not be able to destroy schedulings" do
        should_not be_able_to(:destroy, Factory(:scheduling, plan: another_plan))
      end
    end
  end

  context "As a planner" do
    let(:employee) { Factory(:employee, organization: organization, user: user) }

    context "for other organizations" do
      it "should not be able to read schedulings" do
        should_not be_able_to(:read, Factory(:scheduling, plan: another_plan))
      end

      it "should not be able to update schedulings" do
        should_not be_able_to(:update, Factory(:scheduling, plan: another_plan))
      end

      it "should not be able to create schedulings" do
        should_not be_able_to(:create, Factory.build(:scheduling, plan: another_plan))
      end

      it "should not be able to destroy schedulings" do
        should_not be_able_to(:destroy, Factory(:scheduling, plan: another_plan))
      end
    end
  end

  context "As an employee" do
    let(:employee) { Factory(:employee, organization: organization, user: user) }

    context "for own organization" do
      it "should not be able to destroy schedulings" do
        should_not be_able_to(:destroy, Factory(:scheduling, plan: plan))
      end

      it "should not be able to create schedulings" do
        should_not be_able_to(:create, Factory(:scheduling, plan: plan))
      end

      it "should not be able to update schedulings" do
        should_not be_able_to(:update, Factory(:scheduling, plan: plan))
      end
    end

    context "for other organizations" do
      it "should not be able to read schedulings" do
        should_not be_able_to(:read, Factory(:scheduling, plan: another_plan))
      end

      it "should not be able to update schedulings" do
        should_not be_able_to(:update, Factory(:scheduling, plan: another_plan))
      end

      it "should not be able to create schedulings" do
        should_not be_able_to(:create, Factory.build(:scheduling, plan: another_plan))
      end

      it "should not be able to destroy schedulings" do
        should_not be_able_to(:destroy, Factory(:scheduling, plan: another_plan))
      end
    end
  end

  context "As an user without employee(not possible but for the case)" do
    let(:employee) { nil }

    it "should not be able to read schedulings" do
      should_not be_able_to(:read, Factory(:scheduling, plan: another_plan))
    end

    it "should not be able to destroy schedulings" do
      should_not be_able_to(:destroy, Factory(:scheduling, plan: plan))
    end

    it "should not be able to create schedulings" do
      should_not be_able_to(:create, Factory(:scheduling, plan: plan))
    end

    it "should not be able to update schedulings" do
      should_not be_able_to(:update, Factory(:scheduling, plan: plan))
    end
  end
end