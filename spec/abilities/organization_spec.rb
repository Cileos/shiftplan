require 'spec_helper'
require "cancan/matchers"

describe "Organization permissions:" do
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
    let(:employee) { Factory(:employee_owner, organization: organization, user: user) }

    context "for other organizations" do
      it "should not be able to read organizations" do
        should_not be_able_to(:read, another_organization)
      end

      it "should not be able to update organizations" do
        should_not be_able_to(:update, another_organization)
      end

      it "should not be able to destroy organizations" do
        should_not be_able_to(:destroy, another_organization)
      end
    end
  end

  context "As a planner" do
    let(:employee) { Factory(:employee, organization: organization, user: user) }

    context "for other organizations" do
      it "should not be able to read organizations" do
        should_not be_able_to(:read, another_organization)
      end

      it "should not be able to update organizations" do
        should_not be_able_to(:update, another_organization)
      end

      it "should not be able to destroy organizations" do
        should_not be_able_to(:destroy, another_organization)
      end
    end
  end

  context "As an employee" do
    let(:employee) { Factory(:employee, organization: organization, user: user) }

    context "for own organization" do
      it "should not be able to destroy organizations" do
        should_not be_able_to(:destroy, organization)
      end

      it "should not be able to create organizations" do
        should_not be_able_to(:create, Organization)
      end

      it "should not be able to update organizations" do
        should_not be_able_to(:update, organization)
      end
    end

    context "for other organizations" do
      it "should not be able to read organizations" do
        should_not be_able_to(:read, another_organization)
      end

      it "should not be able to update organizations" do
        should_not be_able_to(:update, another_organization)
      end

      it "should not be able to destroy organizations" do
        should_not be_able_to(:destroy, another_organization)
      end
    end
  end

  context "As an user without employee(not possible but for the case)" do
    let(:employee) { nil }

    it "should not be able to read organizations" do
      should_not be_able_to(:read, organization)
    end

    it "should not be able to destroy organizations" do
      should_not be_able_to(:destroy, organization)
    end

    it "should not be able to create organizations" do
      should_not be_able_to(:create, Organization)
    end

    it "should not be able to update organizations" do
      should_not be_able_to(:update, organization)
    end
  end
end