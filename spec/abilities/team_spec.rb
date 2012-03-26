require 'spec_helper'
require "cancan/matchers"

describe "Team permissions:" do
  subject { ability }
  let(:ability) { Ability.new(user) }
  let(:user) { Factory(:user) }
  let(:organization) { Factory(:organization) }
  let(:another_organization) { Factory(:organization) }

  before(:each) do
    # simulate before_filter :set_current_employee
    user.current_employee = employee if employee
  end

  context "As an owner" do
    let(:employee) { Factory(:owner, organization: organization, user: user) }

    context "for other organizations" do
      it "should not be able to read teams" do
        should_not be_able_to(:read, Factory(:team, organization: another_organization))
      end

      it "should not be able to update teams" do
        should_not be_able_to(:update, Factory(:team, organization: another_organization))
      end

      it "should not be able to create teams" do
        should_not be_able_to(:create, Factory.build(:team, organization: another_organization))
      end

      it "should not be able to destroy teams" do
        should_not be_able_to(:destroy, Factory(:team, organization: another_organization))
      end
    end
  end

  context "As a planner" do
    let(:employee) { Factory(:employee, organization: organization, user: user) }

    context "for other organizations" do
      it "should not be able to read teams" do
        should_not be_able_to(:read, Factory(:team, organization: another_organization))
      end

      it "should not be able to update teams" do
        should_not be_able_to(:update, Factory(:team, organization: another_organization))
      end

      it "should not be able to create teams" do
        should_not be_able_to(:create, Factory.build(:team, organization: another_organization))
      end

      it "should not be able to destroy teams" do
        should_not be_able_to(:destroy, Factory(:team, organization: another_organization))
      end
    end
  end

  context "As an employee" do
    let(:employee) { Factory(:employee, organization: organization, user: user) }

    context "for own organization" do
      it "should not be able to destroy teams" do
        should_not be_able_to(:destroy, Factory(:team, organization: organization))
      end

      it "should not be able to create teams" do
        should_not be_able_to(:create, Factory(:team, organization: organization))
      end

      it "should not be able to update teams" do
        should_not be_able_to(:update, Factory(:team, organization: organization))
      end
    end

    context "for other organizations" do
      it "should not be able to read teams" do
        should_not be_able_to(:read, Factory(:team, organization: another_organization))
      end

      it "should not be able to update teams" do
        should_not be_able_to(:update, Factory(:team, organization: another_organization))
      end

      it "should not be able to create teams" do
        should_not be_able_to(:create, Factory.build(:team, organization: another_organization))
      end

      it "should not be able to destroy teams" do
        should_not be_able_to(:destroy, Factory(:team, organization: another_organization))
      end
    end
  end

  context "As an user without employee(not possible but for the case)" do
    let(:employee) { nil }

    it "should not be able to read teams" do
      should_not be_able_to(:read, Factory(:team, organization: organization))
    end

    it "should not be able to destroy teams" do
      should_not be_able_to(:destroy, Factory(:team, organization: organization))
    end

    it "should not be able to create teams" do
      should_not be_able_to(:create, Factory(:team, organization: organization))
    end

    it "should not be able to update teams" do
      should_not be_able_to(:update, Factory(:team, organization: organization))
    end
  end
end