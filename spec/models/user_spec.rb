# encoding: utf-8
require 'spec_helper'

describe User do

  context "validations" do

    it 'must have a valid email' do
      user = build(:user, email: 'fnørd..d.@p0x.asdt')

      user.should_not be_valid
      user.should have(1).errors_on(:email)
    end
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

    describe 'the user is an owner for' do
      before(:each) { create :employee_owner, user: user, account: account }

      it "are listed" do
        user.organizations.should include(organization)
      end

      it { user.should_not be_multiple }
    end

    describe 'the user is owner for and member in' do
      before(:each) do
        e = create :employee_owner, user: user, account: account
        create :membership, employee: e, organization: organization
      end

      it "are listed uniq" do
        user.organizations.should == [organization]
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

    describe 'the user is planner for' do
      before(:each) do
        e = create :employee, user: user, account: account
        create :membership, employee: e, organization: organization, role: 'planner'
      end

      it "are listed" do
        user.organizations.should == [organization]
      end

      it { user.should_not be_multiple }
    end

    describe 'the user is planner for and member in another org' do
      let(:another_organization) { create(:organization) }

      before(:each) do
        e = create :employee, user: user, account: account
        create :membership, employee: e, organization: organization, role: 'planner'

        create(:membership, employee: e, organization: another_organization)
      end

      it "are listed" do
        user.organizations.count.should == 2
        user.organizations.should include(organization)
        user.organizations.should include(another_organization)
      end

      it { user.should be_multiple }
    end
  end

  describe '#locale' do
    it 'accepts available locales' do
      build(:user, locale: 'de').should be_valid
    end

    it 'does not accept imaginary locale' do
      # kg is not available, but may be used for klingon
      build(:user, locale: 'kg').should_not be_valid
    end
  end

  describe '#plannable_employees' do
    let(:user) { create :user }
    let(:account) { create :account }
    let(:employee) { create :employee, account: account }
    let(:organization) { create :organization, account: account }
    let(:me) { create :employee, account: account, user: user }

    context 'for user being planner in org' do
      before :each do
        create :membership, employee: me, organization: organization, role: 'planner'
      end

      context 'for employee being member in org' do
        let!(:m) { create :membership, employee: employee, organization: organization }

        it 'includes the employee' do
          user.plannable_employees.should include(employee)
        end
      end

      context 'for employee NOT being member in org' do
        let!(:m) { "no membership" }
        it 'excludes the employee' do
          user.plannable_employees.should_not include(employee)
        end
      end
    end

    context 'for user being normal member in org' do
      let!(:m) { create :membership, employee: employee, organization: organization }
      before :each do
        create :membership, employee: me, organization: organization # NO ROLE
      end

      it 'excludes the employee' do
        user.plannable_employees.should_not include(employee)
      end
    end

    context 'for user not being planner in (that) org' do
      let!(:m) { create :membership, employee: employee, organization: organization }
      it 'excludes the employee' do
        user.plannable_employees.should_not include(employee)
      end
    end

    context 'for user being owner of the account' do
      let(:me) { create :employee, user: user, account: account, owned_account: account }
      it 'includes the employee' do
        me && employee
        user.plannable_employees.should include(employee)
      end
    end

  end

  context 'when email changed' do

    let(:user) { create(:confirmed_user, email: 'bart@thesimpsons.com') }

    before do
      user.email = 'lisa@thesimpsons.com'
    end

    it 'creates an email change record' do
      expect do
        user.save!
      end.to change { EmailChange.count }.from(0).to(1)
    end

    it "created email change has correct new email set" do
      user.save!

      change = EmailChange.first
      change.email.should == 'lisa@thesimpsons.com'
    end

    it "does not change the user's email" do
      user.save!

      user.reload.email.should == 'bart@thesimpsons.com'
    end
  end
end
