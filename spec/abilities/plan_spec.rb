require 'spec_helper'
require "cancan/matchers"

describe "Plan permissions:" do
  subject { ability }
  let(:ability) { Ability.new(user) }
  let(:user) { create(:user) }
  let(:organization) { create(:organization) }
  let(:another_organization) { create(:organization) }

  before(:each) do
    # simulate before_filter :set_current_employee
    user.current_employee = employee if employee
  end

  context "As an owner" do
    let(:employee) { create(:employee_owner, organization: organization, user: user) }

    context "for other organizations" do
      it "should not be able to read plans" do
        should_not be_able_to(:read, create(:plan, organization: another_organization))
      end

      it "should not be able to update plans" do
        should_not be_able_to(:update, create(:plan, organization: another_organization))
      end

      it "should not be able to create plans" do
        should_not be_able_to(:create, build(:plan, organization: another_organization))
      end

      it "should not be able to destroy plans" do
        should_not be_able_to(:destroy, create(:plan, organization: another_organization))
      end
    end
  end

  context "As a planner" do
    let(:employee) { create(:employee, organization: organization, user: user) }

    context "for other organizations" do
      it "should not be able to read plans" do
        should_not be_able_to(:read, create(:plan, organization: another_organization))
      end

      it "should not be able to update plans" do
        should_not be_able_to(:update, create(:plan, organization: another_organization))
      end

      it "should not be able to create plans" do
        should_not be_able_to(:create, build(:plan, organization: another_organization))
      end

      it "should not be able to destroy plans" do
        should_not be_able_to(:destroy, create(:plan, organization: another_organization))
      end
    end
  end

  context "As an employee" do
    let(:employee) { create(:employee, organization: organization, user: user) }

    context "for own organization" do
      it "should not be able to destroy plans" do
        should_not be_able_to(:destroy, create(:plan, organization: organization))
      end

      it "should not be able to create plans" do
        should_not be_able_to(:create, create(:plan, organization: organization))
      end

      it "should not be able to update plans" do
        should_not be_able_to(:update, create(:plan, organization: organization))
      end
    end

    context "for other organizations" do
      it "should not be able to read plans" do
        should_not be_able_to(:read, create(:plan, organization: another_organization))
      end

      it "should not be able to update plans" do
        should_not be_able_to(:update, create(:plan, organization: another_organization))
      end

      it "should not be able to create plans" do
        should_not be_able_to(:create, build(:plan, organization: another_organization))
      end

      it "should not be able to destroy plans" do
        should_not be_able_to(:destroy, create(:plan, organization: another_organization))
      end
    end
  end

  context "As an user without employee(not possible but for the case)" do
    let(:employee) { nil }

    it "should not be able to read plans" do
      should_not be_able_to(:read, create(:plan, organization: organization))
    end

    it "should not be able to destroy plans" do
      should_not be_able_to(:destroy, create(:plan, organization: organization))
    end

    it "should not be able to create plans" do
      should_not be_able_to(:create, create(:plan, organization: organization))
    end

    it "should not be able to update plans" do
      should_not be_able_to(:update, create(:plan, organization: organization))
    end
  end
end
