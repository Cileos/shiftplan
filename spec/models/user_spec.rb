require 'spec_helper'

describe User do

  describe 'having role planner' do
    let(:planner) { create(:employee_planner, user: create(:user)) }

    it { planner.should be_a_planner }
    it { planner.should be_role('planner') }
  end

  context "current_employee" do
    let(:user) { create :user }
    let(:employee) { create(:employee, user: user) }

    it "should accept nil" do
      expect { user.current_employee = nil }.not_to raise_error
      user.current_employee.should be_nil
    end

    it "should accept employee who's user is self" do
      expect { user.current_employee = employee }.not_to raise_error
      user.current_employee.should == employee
    end

    let(:foreign_employee) { create(:employee) }
    it "should not accept employee who's user is someone else" do
      expect { user.current_employee = foreign_employee }.to raise_error
    end
  end

  context "notifications" do
    it "should be collected through all employees" do
      u = create :user
      e1 = create :employee, user: u
      e2 = create :employee, user: u

      expect {
        create :notification, employee: e1
        create :notification, employee: e2
      }.to change { u.notifications.count }.by(2)
    end
  end

  context "schedulings" do
    it "should be collected through all employees" do
      u = create :user
      e1 = create :employee, user: u
      e2 = create :employee, user: u

      expect {
        create :scheduling, employee: e1
        create :scheduling, employee: e2
      }.to change { u.schedulings.count }.by(2)
    end
  end

  context "posts of joined organizations" do
    it "should be collected through all employees and their memberships" do
      u = create :user
      e1 = create :employee, user: u
      e2 = create :employee, user: u

      post1 = create :post
      post2 = create :post

      expect {
        Membership.create employee: e1, organization: post1.blog.organization
        Membership.create employee: e2, organization: post2.blog.organization

        create :post
      }.to change { u.posts_of_joined_organizations.count }.by(2)

      u.posts_of_joined_organizations.should include(post1)
      u.posts_of_joined_organizations.should include(post2)
    end
  end

  context "organizations" do
    let(:account)      { create :account }
    let(:organization) { create :organization, account: account }
    let(:user)         { create :user }
    let(:employee)     { create :employee, user: user, account: account }

    before(:each) { organization }

    describe 'the user did not join' do
      before(:each) { employee }

      it "are not listed" do
        user.organizations.should_not include(organization)
      end

      it { user.should_not be_multiple }
    end

    describe 'the user did join as a normal member' do
      before(:each) { create :membership, employee: employee, organization: organization }

      it "are listed" do
        user.organizations.should include(organization)
      end

      it { user.should_not be_multiple }
    end

    describe 'the user is a planner for' do
      before(:each) { create :employee_planner, user: user, account: account }

      it "are listed" do
        user.organizations.should include(organization)
      end

      it { user.should_not be_multiple }
    end

    describe 'the user is an owner for' do
      before(:each) { create :employee_owner, user: user, account: account }

      it "are listed" do
        user.organizations.should include(organization)
      end

      it { user.should_not be_multiple }
    end

    describe 'the user is an owner for and employee in another' do
      before(:each) do
        create :employee_owner, user: user, account: account
        create :membership, employee: create(:employee, user: user)
      end

      it { user.should be_multiple }
    end
  end
end
