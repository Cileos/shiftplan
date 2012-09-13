require 'spec_helper'
require "cancan/matchers"

shared_examples  "an employee who can not create, read, update and destroy schedulings" do
  it "should not be able to create schedulings" do
    should_not be_able_to(:create, create(:scheduling, plan: other_plan))
  end
  it "should not be able to read schedulings" do
    should_not be_able_to(:read, create(:scheduling, plan: other_plan))
  end
  it "should not be able to update schedulings" do
    should_not be_able_to(:update, create(:scheduling, plan: other_plan))
  end
  it "should not be able to destroy schedulings" do
    should_not be_able_to(:destroy, create(:scheduling, plan: other_plan))
  end
end

shared_examples "an employee who can manage schedulings" do
  context "for own accounts" do
    it "should be able to manage schedulings" do
      should be_able_to(:manage, create(:scheduling, plan: plan))
    end
  end
  context "for other accounts" do
    it_behaves_like "an employee who can not create, read, update and destroy schedulings" do
      let(:other_account) { create(:account) }
      let(:other_organization) { create(:organization, account: other_account) }
      let(:other_plan) { create(:plan, organization: other_organization) }
    end
  end
end

shared_examples "an employee who can read schedulings" do
  context "for own accounts" do
    it "should be able to read schedulings" do
      should be_able_to(:read, create(:scheduling, plan: plan))
    end
  end
  context "for other accounts" do
    it_behaves_like "an employee who can not create, read, update and destroy schedulings" do
      # The employee has no membership for the other_organization to wich
      # other_plan belongs.  Therefore he can not even read a scheduling or
      # this other_plan.
      let(:other_organization) { create(:organization, account: account) }
      let(:other_plan) { create(:plan, organization: other_organization) }
    end
  end
end

describe "Scheduling permissions:" do
  subject { ability }
  let(:ability) { Ability.new(user) }
  let(:user) { create(:user) }
  let(:account) { create(:account) }
  let(:organization) { create(:organization, account: account) }
  let(:plan) { create(:plan, organization: organization) }


  before(:each) do
    # simulate before_filter :set_current_employee
    user.current_employee = employee if employee
  end

  context "An owner" do
    it_behaves_like "an employee who can manage schedulings" do
      let(:employee) { create(:employee_owner, account: account, user: user) }
    end
  end

  context "A planner" do
    it_behaves_like "an employee who can manage schedulings" do
      let(:employee) { create(:employee_planner, account: account, user: user) }
    end
  end

  context "An employee" do
    before(:each) do
      membership
    end

    it_behaves_like "an employee who can read schedulings" do
      let(:employee) { create(:employee, account: account, user: user) }
      # An "normal" employee needs a membership for an organization to do things.
      # This is different from planners or owners which do not need a membership but
      # just the role "planner" or "owner" and belong to the acccount.
      let(:membership) { create(:membership, employee: employee, organization: organization) }
    end
  end

  context "An user without employee(not possible but for the case)" do
    let(:employee) { nil }

    it "should not be able to read schedulings" do
      should_not be_able_to(:read, create(:scheduling, plan: plan))
    end

    it "should not be able to destroy schedulings" do
      should_not be_able_to(:destroy, create(:scheduling, plan: plan))
    end

    it "should not be able to create schedulings" do
      should_not be_able_to(:create, create(:scheduling, plan: plan))
    end

    it "should not be able to update schedulings" do
      should_not be_able_to(:update, create(:scheduling, plan: plan))
    end
  end
end
