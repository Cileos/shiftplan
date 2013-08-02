require 'spec_helper'
require "cancan/matchers"

shared_examples "an employee who can read and update organizations" do
  it "should be able to read organizations" do
    should be_able_to(:read, organization)
  end
  it "should be able to update organizations" do
    should be_able_to(:update, organization)
  end
end

shared_examples "an employee who is not able to manage organizations" do
  it "should not be able to create organizations" do
    should_not be_able_to(:create, other_organization)
  end
  it "should not be able to read organizations" do
    should_not be_able_to(:read, other_organization)
  end
  it "should not be able to update organizations" do
    should_not be_able_to(:update, other_organization)
  end
  it "should not be able to destroy organizations" do
    should_not be_able_to(:destroy, other_organization)
  end
end

shared_examples "an owner managing organizations" do
  context "for own accounts" do
    it "should be able to create organizations" do
      should be_able_to(:create, organization)
    end
    it "should be able to update organizations" do
      should be_able_to(:update, organization)
    end
  end
  context "for other accounts" do
    it_behaves_like "an employee who is not able to manage organizations" do
      # organization of a other_account
      let(:other_account) { create(:account) }
      let(:other_organization) { create(:organization, account: other_account) }
    end
  end
end

shared_examples "a planner managing organizations" do
  context "for own accounts" do
    it_behaves_like "an employee who can read and update organizations"
  end
  context "for other accounts" do
    it_behaves_like "an employee who is not able to manage organizations" do
      # organization of a other_account
      let(:other_account) { create(:account) }
      let(:other_organization) { create(:organization, account: other_account) }
    end
  end
end

describe "Organization permissions:" do
  subject { ability }
  let(:ability) { Ability.new(user) }
  let(:user) { create(:user) }
  let(:account) { create(:account) }
  let(:organization) { create(:organization, account: account) }

  before(:each) do
    # simulate before_filter :set_current_employee
    user.current_employee = employee
  end

  context "An owner" do
    it_behaves_like "an owner managing organizations" do
      let(:employee) { create(:employee_owner, account: account, user: user) }
    end
  end

  context "A planner" do
    it_behaves_like "a planner managing organizations" do
      let(:employee) { create(:employee_planner, account: account, user: user) }
    end
  end

  context "An employee" do
    let(:employee) { create(:employee, account: account, user: user) }
    let(:membership) { create(:membership, employee: employee, organization: organization) }

    before(:each) do
      membership
    end

    context "for own organization" do
      it "should be able to read organizations" do
        should be_able_to(:read, organization)
      end
      it "should not be able to create organizations" do
        should_not be_able_to(:create, organization)
      end
      it "should not be able to update organizations" do
        should_not be_able_to(:update, organization)
      end
      it "should not be able to destroy organizations" do
        should_not be_able_to(:destroy, organization)
      end
    end

    context "for other organizations" do
      it_behaves_like "an employee who is not able to manage organizations" do
        # other_organization belongs to same account as organization but the
        # employee is not member of other_organization and therefore can not
        # even read it
        let(:other_organization) { create(:organization, account: account) }
      end
    end
  end

  context "A User" do
    before(:each) do
      membership
      # We test abilities when not being in the scope of an account here.
      # E.g. this is the case when visiting the /dashboard or /accounts.
      # When being in the global scope the current employee can not be
      # determined, therefore it is set to nil here.
      user.current_employee = nil
    end
    let(:membership) { create(:membership, employee: employee, organization: organization) }

    context "with an employee without roles" do
      let(:employee) { create(:employee, account: account, user: user) }

      context "for own organizations" do
        context "for own organization" do
          it "should be able to read organizations" do
            should be_able_to(:read, organization)
          end
          it "should not be able to create organizations" do
            should_not be_able_to(:create, organization)
          end
          it "should not be able to update organizations" do
            should_not be_able_to(:update, organization)
          end
          it "should not be able to destroy organizations" do
            should_not be_able_to(:destroy, organization)
          end
        end
      end

    context "for other organizations" do
      it_behaves_like "an employee who is not able to manage organizations" do
        # other_organization belongs to same account as organization but the
        # employee is not member of other_organization and therefore can not
        # even read it
        let(:other_organization) { create(:organization, account: account) }
      end
    end
    end

    context "with an employee beeing planner" do
      it_behaves_like "a planner managing organizations" do
        let(:employee) { create(:employee_planner, account: account, user: user) }
      end
    end

    context "with an employee beeing owner" do
      it_behaves_like "an owner managing organizations" do
        let(:employee) { create(:employee_owner, account: account, user: user) }
      end
    end
  end
end
