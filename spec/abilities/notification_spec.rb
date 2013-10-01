require 'spec_helper'
require "cancan/matchers"

shared_examples :an_employee_who_can_read_and_update_own_notifications do
  it "should be able to read notifications" do
    should be_able_to(:read, notification)
    should be_able_to(:read, another_notification)
  end
  it "should be able to update notifications" do
    should be_able_to(:update, notification)
    should be_able_to(:update, another_notification)
  end
  it "should not be able to create notifications" do
    should_not be_able_to(:create, notification)
    should_not be_able_to(:create, another_notification)
  end
  it "should not be able to destroy notifications" do
    should_not be_able_to(:destroy, notification)
    should_not be_able_to(:destroy, another_notification)
  end
end

shared_examples :an_employee_who_cannot_crud_foreign_notifications do
  it "should not be able to create notifications" do
    should_not be_able_to(:create, foreign_notification)
  end
  it "should not be able to read notifications" do
    should_not be_able_to(:read, foreign_notification)
  end
  it "should not be able to update notifications" do
    should_not be_able_to(:update, foreign_notification)
  end
  it "should not be able to destroy notifications" do
    should_not be_able_to(:destroy, foreign_notification)
  end
end

describe "Notification permissions:" do
  subject                     { ability }
  let(:ability)               { Ability.new(user) }
  let(:user)                  { create(:user) }
  let(:foreign_user)          { create(:user) }

  let(:account)               { create(:account) }
  let(:another_account)       { create(:account) }
  let(:foreign_account)       { create(:account) }

  let(:organization)          { create(:organization, account: account) }
  let(:another_organization)  { create(:organization, account: another_account) }
  let(:foreign_organization)  { create(:organization, account: foreign_account) }


  before(:each) do
    # The planner role is set on the membership, so a planner can only be
    # a planner for a certain membership/organization.
    # Simulate CanCan's current_ability method by setting the current
    # membership and employee manually here.
    user.current_membership = membership if membership
    user.current_employee = employee if employee
  end

  let!(:another_employee) { create(:employee, account: another_account, user: user) }
  let!(:another_membership) do
    create(:membership,
      employee: another_employee,
      organization: another_organization)
  end

  let!(:foreign_employee) { create(:employee, account: foreign_account, user: foreign_user) }
  let!(:foreign_membership) do
    create(:membership,
      employee: foreign_employee,
      organization: foreign_organization)
  end

  let(:notification) do
    create(:upcoming_scheduling_notification, employee: employee)
  end
  let(:another_notification) do
    create(:upcoming_scheduling_notification, employee: another_employee)
  end
  let(:foreign_notification) do
    create(:upcoming_scheduling_notification, employee: foreign_employee)
  end

  context "An owner" do
    let!(:employee)  { create(:employee_owner, account: account, user: user) }
    let(:membership) { nil }

    it_behaves_like :an_employee_who_can_read_and_update_own_notifications
    it_behaves_like :an_employee_who_cannot_crud_foreign_notifications
  end

  context "A planner" do
    let(:employee) { create(:employee, account: account, user: user) }
    let(:membership) do
      create(:membership,
        role: 'planner',
        employee: employee,
        organization: organization)
    end

    it_behaves_like :an_employee_who_can_read_and_update_own_notifications
    it_behaves_like :an_employee_who_cannot_crud_foreign_notifications
  end

  context "An employee" do
    let(:employee) { create(:employee, account: account, user: user) }
    let!(:membership)  do
      create(:membership, employee: employee, organization: organization)
    end

    it_behaves_like :an_employee_who_can_read_and_update_own_notifications
    it_behaves_like :an_employee_who_cannot_crud_foreign_notifications
  end
end
