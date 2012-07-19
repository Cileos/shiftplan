require 'spec_helper'
require "cancan/matchers"

describe "Employee permissions:" do
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

    context "for own organization" do
      it "should not be able to destroy employees" do
        should_not be_able_to(:destroy, create(:employee, organization: organization))
      end
    end

    context "for other organizations" do
      it "should not be able to read employees" do
        should_not be_able_to(:read, create(:employee, organization: another_organization))
      end

      it "should not be able to update employees" do
        should_not be_able_to(:update, create(:employee, organization: another_organization))
      end

      it "should not be able to create employees" do
        should_not be_able_to(:create, build(:employee, organization: another_organization))
      end

      it "should not be able to destroy employees" do
        should_not be_able_to(:destroy, create(:employee, organization: another_organization))
      end
    end
  end

  context "As a planner" do
    let(:employee) { create(:employee_planner, organization: organization, user: user) }

    context "for own organization" do
      it "should not be able to destroy employees" do
        should_not be_able_to(:destroy, create(:employee, organization: organization))
      end
    end

    context "for other organizations" do
      it "should not be able to read employees" do
        should_not be_able_to(:read, create(:employee, organization: another_organization))
      end

      it "should not be able to update employees" do
        should_not be_able_to(:update, create(:employee, organization: another_organization))
      end

      it "should not be able to create employees" do
        should_not be_able_to(:create, build(:employee, organization: another_organization))
      end

      it "should not be able to destroy employees" do
        should_not be_able_to(:destroy, create(:employee, organization: another_organization))
      end
    end
  end

  context "As an employee" do
    let(:employee) { create(:employee, organization: organization, user: user) }

    context "for own organization" do
      it "should not be able to destroy employees" do
        should_not be_able_to(:destroy, create(:employee, organization: organization))
      end

      it "should not be able to create employees" do
        should_not be_able_to(:create, create(:employee, organization: organization))
      end

      it "should not be able to update employees" do
        should_not be_able_to(:update, create(:employee, organization: organization))
      end
    end

    context "for other organizations" do
      it "should not be able to read employees" do
        should_not be_able_to(:read, create(:employee, organization: another_organization))
      end

      it "should not be able to update employees" do
        should_not be_able_to(:update, create(:employee, organization: another_organization))
      end

      it "should not be able to create employees" do
        should_not be_able_to(:create, build(:employee, organization: another_organization))
      end

      it "should not be able to destroy employees" do
        should_not be_able_to(:destroy, create(:employee, organization: another_organization))
      end
    end
  end

  context "As an user without employee(not possible but for the case)" do
    let(:employee) { nil }

    it "should not be able to read employees" do
      should_not be_able_to(:read, create(:employee, organization: organization))
    end

    it "should not be able to destroy employees" do
      should_not be_able_to(:destroy, create(:employee, organization: organization))
    end

    it "should not be able to create employees" do
      should_not be_able_to(:create, create(:employee, organization: organization))
    end

    it "should not be able to update employees" do
      should_not be_able_to(:update, create(:employee, organization: organization))
    end
  end
end
