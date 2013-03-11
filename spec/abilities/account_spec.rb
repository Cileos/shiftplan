require 'spec_helper'
require "cancan/matchers"

shared_examples "an employee who can read accounts" do
  context "for own accounts" do
    it "should be able to read accounts" do
      should be_able_to(:read, account)
    end
    it "should not be able to update accounts" do
      should_not be_able_to(:update, account)
    end
    it "should not be able to destroy accounts" do
      should_not be_able_to(:destroy, account)
    end
  end
  context "for other accounts" do
    it_behaves_like "an employee who cannot read, create, update and destroy accounts"
  end
end

shared_examples "an employee who cannot read, create, update and destroy accounts" do
  it "should not be able to read accounts" do
    should_not be_able_to(:read, other_account)
  end
  it "should not be able to update accounts" do
    should_not be_able_to(:update, other_account)
  end
  it "should not be able to destroy accounts" do
    should_not be_able_to(:destroy, other_account)
  end
end

shared_examples "an employee who can read and update accounts" do
  context "for own accounts" do
    it "should be able to read accounts" do
      should be_able_to(:read, account)
    end
    it "should be able to update accounts" do
      should be_able_to(:update, account)
    end
    it "should not be able to destroy accounts" do
      should_not be_able_to(:destroy, account)
    end
  end
  context "for other accounts" do
    it_behaves_like "an employee who cannot read, create, update and destroy accounts"
  end
end

shared_examples "a user who can create accounts" do
  context "for own user" do
    it "should be able to create accounts" do
      should be_able_to(:create, Account.new(user_id: user.id))
    end
  end
  context "for other users" do
    it "should not be able to create accounts" do
      should_not be_able_to(:create, Account.new(user_id: other_user.id))
    end
  end
end

describe "Account permissions:" do
  subject              { ability }
  let(:ability)        { Ability.new(user) }
  let(:user)           { create(:user) }
  let(:other_user)     { create(:user) }
  let(:account)        { create(:account) }
  let(:organization)   { create(:organization, account: account) }

  let(:other_account)  { create(:account) }

  before(:each) do
    # simulate before_filter :set_current_employee
    user.current_employee = employee if employee
  end

  context "An owner" do
    let(:employee) { create(:employee_owner, account: account, user: user) }

    it_behaves_like "an employee who can read and update accounts"
    it_behaves_like "a user who can create accounts"
  end

  context "A planner" do
    let(:employee) { create(:employee_planner, account: account, user: user) }

    it_behaves_like "an employee who can read accounts"
    it_behaves_like "a user who can create accounts"
  end

  context "An employee" do
    let(:employee) { create(:employee, account: account, user: user) }

    it_behaves_like "an employee who can read accounts"
    it_behaves_like "a user who can create accounts"
  end

  context "An user without employee(not possible but for the case)" do
    let(:employee) { nil }

    it_behaves_like "a user who can create accounts"

    it "should not be able to read accounts" do
      should_not be_able_to(:read, account)
    end
    it "should not be able to update accounts" do
      should_not be_able_to(:update, account)
    end
    it "should not be able to destroy accounts" do
      should_not be_able_to(:destroy, account)
    end
  end
end
