require 'spec_helper'
require "cancan/matchers"

shared_examples  "an employee who can not create, read, update and destroy shifts" do
  it "should not be able to create shifts" do
    should_not be_able_to(:create, create(:shift, plan_template: other_plan_template))
  end
  it "should not be able to read shifts" do
    should_not be_able_to(:read, create(:shift, plan_template: other_plan_template))
  end
  it "should not be able to update shifts" do
    should_not be_able_to(:update, create(:shift, plan_template: other_plan_template))
  end
  it "should not be able to destroy shifts" do
    should_not be_able_to(:destroy, create(:shift, plan_template: other_plan_template))
  end
end

shared_examples "an employee who can manage shifts" do
  context "for own accounts" do
    it "should be able to manage shifts" do
      should be_able_to(:manage, create(:shift, plan_template: plan_template))
    end
  end
  context "for other accounts" do
    it_behaves_like "an employee who can not create, read, update and destroy shifts" do
      let(:other_account) { create(:account) }
      let(:other_organization) { create(:organization, account: other_account) }
      let(:other_plan_template) { create(:plan_template, organization: other_organization) }
    end
  end
end

shared_examples "an employee who can not read shifts" do
  context "for own accounts" do
    it "should not be able to read shifts" do
      should_not be_able_to(:read, create(:shift, plan_template: plan_template))
    end
  end
  context "for other accounts" do
    it_behaves_like "an employee who can not create, read, update and destroy shifts" do
      # The employee has no membership for the other_organization to wich
      # other_plan_template belongs.  Therefore he can not even read a shift or
      # this other_plan_template.
      let(:other_organization) { create(:organization, account: account) }
      let(:other_plan_template) { create(:plan_template, organization: other_organization) }
    end
  end
end

describe "Shift permissions:" do
  subject { ability }
  let(:ability) { Ability.new(user) }
  let(:user) { create(:user) }
  let(:account) { create(:account) }
  let(:organization) { create(:organization, account: account) }
  let(:plan_template) { create(:plan_template, organization: organization) }


  before(:each) do
    # simulate before_filter :set_current_employee
    user.current_employee = employee if employee
  end

  context "An owner" do
    it_behaves_like "an employee who can manage shifts" do
      let(:employee) { create(:employee_owner, account: account, user: user) }
    end
  end

  context "A planner" do
    it_behaves_like "an employee who can manage shifts" do
      let(:employee) { create(:employee_planner, account: account, user: user) }
    end
  end

  context "An employee" do
    before(:each) do
      membership
    end

    it_behaves_like "an employee who can not read shifts" do
      let(:employee) { create(:employee, account: account, user: user) }
      # An "normal" employee needs a membership for an organization to do things.
      # This is different from planners or owners which do not need a membership but
      # just the role "planner" or "owner" and belong to the acccount.
      let(:membership) { create(:membership, employee: employee, organization: organization) }
    end
  end

  context "An user without employee(not possible but for the case)" do
    let(:employee) { nil }

    it "should not be able to read shifts" do
      should_not be_able_to(:read, create(:shift, plan_template: plan_template))
    end

    it "should not be able to destroy shifts" do
      should_not be_able_to(:destroy, create(:shift, plan_template: plan_template))
    end

    it "should not be able to create shifts" do
      should_not be_able_to(:create, create(:shift, plan_template: plan_template))
    end

    it "should not be able to update shifts" do
      should_not be_able_to(:update, create(:shift, plan_template: plan_template))
    end
  end
end
