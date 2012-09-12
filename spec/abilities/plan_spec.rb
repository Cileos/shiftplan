require 'spec_helper'
require "cancan/matchers"

shared_examples "a planner for own accounts" do
  it "should be able to manage plans" do
    should be_able_to(:manage, create(:plan, organization: organization))
  end
end

shared_examples "a planner for other accounts" do
  it "should not be able to read plans" do
    should_not be_able_to(:read, create(:plan, organization: other_organization))
  end
  it "should not be able to update plans" do
    should_not be_able_to(:update, create(:plan, organization: other_organization))
  end
  it "should not be able to create plans" do
    should_not be_able_to(:create, build(:plan, organization: other_organization))
  end
  it "should not be able to destroy plans" do
    should_not be_able_to(:destroy, create(:plan, organization: other_organization))
  end
end

shared_examples "a planning planner" do
  it_behaves_like "a planner for own accounts"
  it_behaves_like "a planner for other accounts"
end

describe "Plan permissions:" do
  subject { ability }
  let(:ability) { Ability.new(user) }
  let(:user) { create(:user) }

  let(:account) { create(:account) }
  let(:organization) { create(:organization, account: account) }
  let(:another_organization) { create(:organization, account: account) }

  let(:other_account) { create(:account) }
  let(:other_organization) { create(:organization, account: other_account) }

  before(:each) do
    # simulate before_filter :set_current_employee
    user.current_employee = employee if employee
  end

  context "An owner" do
    let(:employee) { create(:employee_owner, account: account, user: user) }

    it_behaves_like "a planning planner"
  end

  context "As a planner" do
    let(:employee) { create(:employee_planner, account: account, user: user) }

    it_behaves_like "a planning planner"
  end

  context "As an employee" do
    let(:employee)   { create(:employee, account: account, user: user) }
    # An "normal" employee needs a membership for an organization to do things.
    # This is different from planners or owners which do not need a membership but
    # just the role "planner" or "owner" and belong to the acccount.
    let(:membership) { create(:membership, employee: employee, organization: organization) }

    before(:each) do
      membership
    end

    context "for own organizations" do
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

    context "for other organizations" do
      it_behaves_like "a planner for other accounts"
    end

    context "for organizations of different accounts" do
      it_behaves_like "a planner for other accounts"
    end
  end

  context "As an user without employee(not possible but for the case)" do
    let(:employee) { nil }

    it_behaves_like "a planner for other accounts"
  end
end
