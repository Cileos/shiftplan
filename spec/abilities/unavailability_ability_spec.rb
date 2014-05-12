require 'spec_helper'
require "cancan/matchers"


describe 'Unavailability permissions:' do
  subject              { ability }
  let(:ability)        { Ability.new(user) }
  let(:user)           { create(:user) }
  let(:other_user)     { create(:user) }
  let(:account)        { create(:account) }
  let(:organization)   { create(:organization, account: account) }
  let(:other_account)  { create(:account) }
  let(:employee)       { build(:employee) }

  before :each do
    user.stub accounts: [account]
  end

  describe "user being planner for the una's employee" do
    before :each do
      user.stub plannable_employees: [employee]
    end

    context "in one of the users accounts" do
      let(:unavailability) { build :unavailability, accounts: [account], user: employee.user, employee: employee }
      it 'can manage' do
        should be_able_to(:manage, unavailability)
      end
    end

    context "outside of the user's accounts" do
      let(:unavailability) { build :unavailability, accounts: [other_account, account], user: employee.user, employee: employee }
      it 'cannot manage' do
        should_not be_able_to(:manage, unavailability)
      end
    end
  end

  describe 'self-planning user' do
    before :each do
      user.stub plannable_employees: []
    end

    context "in any of the users accounts" do
      let(:unavailability) { build :unavailability, accounts: [account], user: user, employee: nil }
      it 'can manage' do
        should be_able_to(:manage, unavailability)
      end
    end

    context "outside of the user's accounts" do
      let(:unavailability) { build :unavailability, accounts: [other_account, account], user: user, employee: nil }
      it 'cannot manage' do
        should_not be_able_to(:manage, unavailability)
      end
    end
  end
end
