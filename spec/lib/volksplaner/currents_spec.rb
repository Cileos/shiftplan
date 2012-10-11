require 'spec_helper'

describe Volksplaner::Currents do
  it { described_class.should be_a(Module) }

  let(:controller_class) { Class.new(ActionController::Base) }

  it "should set some helper methods on including controller" do
    controller_class.should_receive(:helper_method).at_least(6).times
    controller_class.send :include, described_class
  end

  describe 'included into a controller' do
    before :each do
      controller_class.send :include, described_class
      controller.stub(:current_user).and_return( user )
    end
    let(:controller) { controller_class.new }

    let(:account)      { mock 'Account' }
    let(:organization) { mock 'Organization' }
    let(:user)         { mock 'User', :current_employee= => true}
    let(:employee)     { mock 'Employee' }

    it "should set current employee from current account and user" do
      controller.stub(:current_account).and_return(account)
      controller.stub(:current_user).and_return(user)
      user.should_receive(:employee_for_account).with(account).and_return(employee)
      controller.current_employee.should == employee
    end

    shared_examples 'nonambiguous employee' do
      it "should detect current employee" do
        controller.should be_current_employee
      end
      it "should find current employee" do
        controller.current_employee.should == employee
      end
    end
    shared_examples 'nonambiguous account' do
      it "should detect current account" do
        controller.should be_current_account
      end
      it "should find current account" do
        controller.current_account.should == account
      end
    end
    shared_examples 'nonambiguous organization' do
      it "should detect current organization" do
        controller.should be_current_organization
      end
      it "should find current organization" do
        controller.current_organization.should == organization
      end
    end

    shared_examples 'ambiguous employee' do
      it "should not detect current employee" do
        controller.should_not be_current_employee
      end
      it "should not find current employee" do
        controller.current_employee.should be_blank
      end
    end
    shared_examples 'ambiguous account' do
      it "should not detect current account" do
        controller.should_not be_current_account
      end
      it "should not find current account" do
        controller.current_account.should be_blank
      end
    end
    shared_examples 'ambiguous organization' do
      it "should not detect current organization" do
        controller.should_not be_current_organization
      end
      it "should not find current organization" do
        controller.current_organization.should be_blank
      end
    end

    shared_examples 'ambiguous' do
      it_should_behave_like 'ambiguous employee'
      it_should_behave_like 'ambiguous account'
      it_should_behave_like 'ambiguous organization'
    end
    shared_examples 'nonambiguous' do
      it_should_behave_like 'nonambiguous employee'
      it_should_behave_like 'nonambiguous account'
      it_should_behave_like 'nonambiguous organization'
    end

    context 'having params' do
      before :each do
        controller.stub(:params).and_return(params)
      end

      context "with numeric account_id" do
        let(:params) { {account_id: 23} }
        it "should set current_account" do
          Account.should_receive(:find).with(23).and_return(account)
          controller.current_account.should == account
        end
      end

      context "with numeric organization_id and detected account" do
        let(:params) { {organization_id: 77} }
        it "should provide current_organization" do
          controller.stub(:current_account).and_return(account)
          possibilities = mock 'relation', find: organization
          user.should_receive(:organizations_for).with(account).and_return(possibilities)
          controller.current_organization.should == organization
        end
      end

    end

    context 'without direct params (dashboard)' do

      before(:each)      { membership.should be_persisted }
      before :each do
        controller.stub(:params).and_return({})
      end

      let(:user)         { create :user }
      let(:account)      { create :account }
      let(:organization) { create :organization, account: account }
      let(:membership)   { create :membership, employee: employee, organization: organization }
      let(:employee)     { create role, account: account, user: user }

      context "not signed in" do
        let(:role)  { :employee }
        before :each do
          controller.stub(:user_signed_in? => false, current_user: nil)
        end

        it_should_behave_like 'ambiguous'
      end

      context "owning one account" do
        let(:role)  { :employee_owner }

        it_should_behave_like 'nonambiguous'
      end

      context "member in one organization" do
        let(:role)  { :employee }

        it_should_behave_like 'nonambiguous'
      end

      context "member in multiple organizations of same account" do
        let(:role)               { :employee }
        let(:other_organization) { create :organization, account: account } # <<<<<<<<<
        let(:other_membership)   { create :membership, employee: employee, organization: other_organization }
        before(:each)            { other_membership.should be_persisted }

        it_should_behave_like 'ambiguous employee'
        it_should_behave_like 'ambiguous organization'
      end

      context "member in multiple organization of different accounts" do
        let(:role)               { :employee }
        let(:other_account)      { create :account }
        let(:other_organization) { create :organization, account: other_account } # <<<<<<<<<
        let(:other_membership)   { create :membership, employee: employee, organization: other_organization }
        before(:each)            { other_membership.should be_persisted }

        it_should_behave_like 'ambiguous employee'
        it_should_behave_like 'ambiguous organization'
      end

      context "owner employee of one account, member in another" do
        let(:role)               { :employee_owner }
        let(:other_account)      { create :account }
        let(:other_employee)     { create :employee, account: other_account, user: user }
        let(:other_organization) { create :organization, account: other_account }
        let(:other_membership)   { create :membership, employee: other_employee, organization: other_organization }
        before(:each)            { other_membership.should be_persisted }

        it_should_behave_like 'ambiguous'
      end

    end
  end
end
