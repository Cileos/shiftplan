require 'spec_helper'
require "cancan/matchers"

shared_examples "an user who can read and update itself" do
  it "should be able to read itself" do
    should be_able_to(:read, user)
  end
  it "should be able to update itself" do
    should be_able_to(:update, user)
  end

  it "should not be able to read other users" do
    should_not be_able_to(:read, other_user)
  end
  it "should be able to update other users" do
    should_not be_able_to(:update, other_user)
  end

  it "should not be able to create users" do
    should_not be_able_to(:create, User)
  end
  it "should not be able to destroy users" do
    should_not be_able_to(:destroy, User)
  end
end

describe "User permissions:" do
  subject { ability }
  let(:ability) { Ability.new(user) }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:account) { create(:account) }

  before(:each) do
    # simulate before_filter :set_current_employee
    user.current_employee = employee if employee
  end

  context "An owner" do
    it_behaves_like "an user who can read and update itself" do
      let(:employee) { create(:employee_owner, account: account, user: user) }
    end
  end

  context "A planner" do
    it_behaves_like "an user who can read and update itself" do
      let(:employee) { create(:employee_planner, account: account, user: user) }
    end
  end

  context "An employee" do
    it_behaves_like "an user who can read and update itself" do
      let(:employee) { create(:employee, account: account, user: user) }
    end
  end

  context "An user without employee(not possible but for the case)" do
    it_behaves_like "an user who can read and update itself" do
      let(:employee) { nil }
    end
  end
end
