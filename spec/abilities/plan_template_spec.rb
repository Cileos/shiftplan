require 'spec_helper'
require "cancan/matchers"

shared_examples  "an employee who can not create, read, update and destroy plan_templates" do
  it "should not be able to create plan_templates" do
    should_not be_able_to(:create, create(:plan_template, organization: other_organization))
  end
  it "should not be able to read plan_templates" do
    should_not be_able_to(:read, create(:plan_template, organization: other_organization))
  end
  it "should not be able to update plan_templates" do
    should_not be_able_to(:update, create(:plan_template, organization: other_organization))
  end
  it "should not be able to destroy plan_templates" do
    should_not be_able_to(:destroy, create(:plan_template, organization: other_organization))
  end
end

shared_examples "an employee who can manage plan_templates" do
  context "for own accounts" do
    it "should be able to manage plan_templates" do
      should be_able_to(:manage, create(:plan_template, organization: organization))
    end
  end
  context "for other accounts" do
    it_behaves_like "an employee who can not create, read, update and destroy plan_templates" do
      let(:other_account) { create(:account) }
      let(:other_organization) { create(:organization, account: other_account) }
      let(:other_plan) { create(:plan, organization: other_organization) }
    end
  end
end

shared_examples "an employee who can not read plan_templates" do
  context "for own accounts" do
    it "should not be able to read plan_templates" do
      should_not be_able_to(:read, create(:plan_template, organization: organization))
    end
  end
  context "for other accounts" do
    it_behaves_like "an employee who can not create, read, update and destroy plan_templates" do
      # The employee has no membership for the other_organization.
      # Therefore he can not even read a plan_template.
      let(:other_organization) { create(:organization, account: account) }
    end
  end
end

describe "plan_template permissions:" do
  subject { ability }
  let(:ability) { Ability.new(user) }
  let(:user) { create(:user) }
  let(:account) { create(:account) }
  let(:organization) { create(:organization, account: account) }


  before(:each) do
    # simulate before_filter :set_current_employee
    user.current_employee = employee if employee
  end

  context "An owner" do
    it_behaves_like "an employee who can manage plan_templates" do
      let(:employee) { create(:employee_owner, account: account, user: user) }
    end
  end

  context "A planner" do
    it_behaves_like "an employee who can manage plan_templates" do
      let(:employee) { create(:employee_planner, account: account, user: user) }
    end
  end

  context "An employee" do
    before(:each) do
      membership
    end

    it_behaves_like "an employee who can not read plan_templates" do
      let(:employee) { create(:employee, account: account, user: user) }
      # An "normal" employee needs a membership for an organization to do things.
      # This is different from planners or owners which do not need a membership but
      # just the role "planner" or "owner" and belong to the acccount.
      let(:membership) { create(:membership, employee: employee, organization: organization) }
    end
  end

  context "An user without employee(not possible but for the case)" do
    let(:employee) { nil }

    it "should not be able to read plan_templates" do
      should_not be_able_to(:read, create(:plan_template, organization: organization))
    end

    it "should not be able to destroy plan_templates" do
      should_not be_able_to(:destroy, create(:plan_template, organization: organization))
    end

    it "should not be able to create plan_templates" do
      should_not be_able_to(:create, create(:plan_template, organization: organization))
    end

    it "should not be able to update plan_templates" do
      should_not be_able_to(:update, create(:plan_template, organization: organization))
    end
  end
end
