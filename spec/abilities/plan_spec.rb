require 'spec_helper'
require "cancan/matchers"

describe "Plan permissions:" do
  subject { ability }
  let(:ability) { Ability.new(user) }
  let(:user) { create(:user) }

  let(:account) { create(:account) }
  let(:organization) { create(:organization, account: account) }
  let(:another_organization) { create(:organization, account: account) }

  let(:different_account) { create(:account) }
  let(:different_organization) { create(:organization, account: different_account) }

  before(:each) do
    # simulate before_filter :set_current_employee
    user.current_employee = employee if employee
  end

  context "As an owner" do
    let(:employee) { create(:employee_owner, account: account, user: user) }

    context "for organizations of different accounts" do
      it "should not be able to read plans" do
        should_not be_able_to(:read, create(:plan, organization: different_organization))
      end

      it "should not be able to update plans" do
        should_not be_able_to(:update, create(:plan, organization: different_organization))
      end

      it "should not be able to create plans" do
        should_not be_able_to(:create, build(:plan, organization: different_organization))
      end

      it "should not be able to destroy plans" do
        should_not be_able_to(:destroy, create(:plan, organization: different_organization))
      end
    end

    context "for own organizations" do
      it "should be able to read plans" do
        should be_able_to(:read, create(:plan, organization: organization))
      end

      it "should be able to update plans" do
        should be_able_to(:update, create(:plan, organization: organization))
      end

      it "should be able to create plans" do
        should be_able_to(:create, build(:plan, organization: organization))
      end

      it "should be able to destroy plans" do
        should be_able_to(:destroy, create(:plan, organization: organization))
      end
    end
  end

  context "As a planner" do
    let(:employee) { create(:employee_planner, account: account, user: user) }

    context "for organizations of different accounts" do
      it "should not be able to read plans" do
        should_not be_able_to(:read, create(:plan, organization: different_organization))
      end

      it "should not be able to update plans" do
        should_not be_able_to(:update, create(:plan, organization: different_organization))
      end

      it "should not be able to create plans" do
        should_not be_able_to(:create, build(:plan, organization: different_organization))
      end

      it "should not be able to destroy plans" do
        should_not be_able_to(:destroy, create(:plan, organization: different_organization))
      end
    end

    context "for own organizations" do
      it "should be able to read plans" do
        should be_able_to(:read, create(:plan, organization: organization))
      end

      it "should be able to update plans" do
        should be_able_to(:update, create(:plan, organization: organization))
      end

      it "should be able to create plans" do
        should be_able_to(:create, build(:plan, organization: organization))
      end

      it "should be able to destroy plans" do
        should be_able_to(:destroy, create(:plan, organization: organization))
      end
    end
  end

  context "As an employee" do
    let(:employee)   { create(:employee, account: account, user: user) }
    let(:membership) { create(:membership, employee: employee, organization: organization) }

    before(:each) do
      membership
    end

    context "for organizations of which (s)he is member of" do
      it "should be able to read plans" do
        should be_able_to(:read, create(:plan, organization: organization))
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

    context "for organizations of which (s)he is not member of" do
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

    context "for organizations of different accounts" do
      it "should not be able to read plans" do
        should_not be_able_to(:read, create(:plan, organization: different_organization))
      end

      it "should not be able to update plans" do
        should_not be_able_to(:update, create(:plan, organization: different_organization))
      end

      it "should not be able to create plans" do
        should_not be_able_to(:create, build(:plan, organization: different_organization))
      end

      it "should not be able to destroy plans" do
        should_not be_able_to(:destroy, create(:plan, organization: different_organization))
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
