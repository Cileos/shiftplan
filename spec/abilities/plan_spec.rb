require 'spec_helper'
require "cancan/matchers"

# TODO take out of global scope or name accordingly
shared_examples :a_planner_for_own_organizations do
  it "should be able to manage plans" do
    should be_able_to(:manage, create(:plan, organization: organization))
  end
end

shared_examples :a_planner_for_own_organizations do
  it "should be able to manage plans" do
    should be_able_to(:manage, create(:plan, organization: organization))
  end
end

shared_examples :an_employee_for_other_organizations do
  it "should not be able to read plans" do
    should_not be_able_to(:read, create(:plan, organization: another_organization))
  end

  it "should not be able to destroy plans" do
    should_not be_able_to(:destroy, create(:plan, organization: another_organization))
  end

  it "should not be able to create plans" do
    should_not be_able_to(:create, create(:plan, organization: another_organization))
  end

  it "should not be able to update plans" do
    should_not be_able_to(:update, create(:plan, organization: another_organization))
  end
end

shared_examples :an_employee_without_any_planning_permissions_in_other_accounts do
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

shared_examples :a_planning_owner do
  it_behaves_like :a_planner_for_own_organizations
  it_behaves_like :an_employee_without_any_planning_permissions_in_other_accounts
end

shared_examples :a_planning_planner do
  it_behaves_like :a_planner_for_own_organizations
  it_behaves_like :an_employee_for_other_organizations
  it_behaves_like :an_employee_without_any_planning_permissions_in_other_accounts
end

describe "Plan permissions:" do
  subject { ability }
  let(:ability) { Ability.new(user) }
  let(:user) { create(:user) }

  let(:account)               { create(:account) }
  let(:organization)          { create(:organization, account: account) }
  let(:another_organization)  { create(:organization, account: account) }

  let(:other_organization) { create(:organization) }

  before(:each) do
    # Simulate CanCan's current_ability method by setting the current
    # employee manually here.
    user.current_employee = employee if employee
  end

  context "An owner" do
    it_behaves_like :a_planning_owner do
      let(:employee) { create(:employee_owner, account: account, user: user) }
    end
  end

  context "A planner" do
    before(:each) do
      # The planner role is set on the membership, so a planner can only be
      # a planner for a certain membership/organization.
      # Simulate CanCan's current_ability method by setting the current
      # membership manually here.
      user.current_membership = membership
    end

    it_behaves_like :a_planning_planner do
      let(:employee) { create(:employee, account: account, user: user) }
      let(:membership) do
        create(:membership,
          role: 'planner',
          employee: employee,
          organization: organization)
      end
    end
  end

  context "An employee" do
    let(:employee)   { create(:employee, account: account, user: user) }
    # An "normal" employee needs a membership for an organization to do things.
    # This is different from planners or owners which do not need a membership but
    # just the role "planner" or "owner" and belong to the acccount.
    let!(:membership) { create(:membership, employee: employee, organization: organization) }

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
      it "should be able to read plans" do
        should_not be_able_to(:read, create(:plan, organization: another_organization))
      end

      it "should not be able to destroy plans" do
        should_not be_able_to(:destroy, create(:plan, organization: another_organization))
      end

      it "should not be able to create plans" do
        should_not be_able_to(:create, create(:plan, organization: another_organization))
      end

      it "should not be able to update plans" do
        should_not be_able_to(:update, create(:plan, organization: another_organization))
      end
    end

    context "for organizations of different accounts" do
      it_behaves_like :an_employee_without_any_planning_permissions_in_other_accounts
    end
  end

  context "An user without employee(not possible but for the case)" do
    let(:employee) { nil }

    it_behaves_like :an_employee_without_any_planning_permissions_in_other_accounts
  end
end
