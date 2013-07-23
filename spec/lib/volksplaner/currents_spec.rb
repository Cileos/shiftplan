require 'spec_helper'

describe Volksplaner::Currents do
  it { described_class.should be_a(Module) }

  let!(:controller_class)  { Class.new(ActionController::Base) }
  let!(:controller)        { controller_class.new }
  let!(:user)              { create(:user) }
  let!(:account_1)         { create(:account) }
  let!(:account_2)         { create(:account) }
  let!(:employee_1)        { create(:employee, user: user, account: account_1) }
  let!(:employee_2)        { create(:employee, user: user, account: account_2) }

  it "should set some helper methods on including controller" do
    controller_class.should_receive(:helper_method).at_least(6).times
    controller_class.send :include, described_class
  end

  context "#current_account" do
    before(:each) { controller_class.send :include, described_class }

    context "when logged in" do
      before(:each) do
        controller.stub(:current_user).and_return(user)
        controller.stub(:params).and_return(params)
      end

      context "with account params " do

        context "when in the scope of an account" do
          let(:params) { { controller: 'accounts', id: account_1.id } }

          it "sets the current account to account specified in the params" do
            controller.current_account.should == account_1
          end
        end

        context "when in a subordinate scope of an account" do
          let(:params) { { account_id: account_1.id } }

          it "sets the current account to account specified in the params" do
            controller.current_account.should == account_1
          end
        end
      end

      # user is on dashboard for example
      context "without account params" do
        let(:params) { {} }

        context "for user with multiple accounts" do
          it "does not set the current account" do
            controller.current_account.should be_nil
          end
        end

        context "for user with exactly one account" do
          before(:each) do
            controller.current_user.stub(:accounts).and_return([account_1])
          end
          it "does set the current account to the account of the user" do
            controller.current_account.should == account_1
          end
        end

      end

    end

    context "when not logged in" do
      before(:each) do
        controller.stub(:current_user).and_return(nil)
      end

      it "does not set the current account" do
        controller.current_account.should be_nil
      end
    end


  end

  # describe 'included into a controller' do
  #   before :each do
  #     controller_class.send :include, described_class
  #     controller.stub(:current_user).and_return( user )
  #   end
  #   let(:controller) { controller_class.new }

  #   let(:account)      { mock 'Account' }
  #   let(:organization) { mock 'Organization' }
  #   let(:user)         do
  #     mock('User',
  #       :current_employee= => true,
  #       :current_membership= => true)
  #   end
  #   let(:employee)     { mock 'Employee' }

  #   it "should set current employee from current account and user" do
  #     controller.stub(:current_account).and_return(account)
  #     controller.stub(:current_user).and_return(user)
  #     user.should_receive(:employee_for_account).with(account).and_return(employee)
  #     controller.current_employee.should == employee
  #   end

  #   shared_examples 'nonambiguous employee' do
  #     it "should detect current employee" do
  #       controller.should be_current_employee
  #     end
  #     it "should find current employee" do
  #       controller.current_employee.should == employee
  #     end
  #   end
  #   shared_examples 'nonambiguous account' do
  #     it "should detect current account" do
  #       controller.should be_current_account
  #     end
  #     it "should find current account" do
  #       controller.current_account.should == account
  #     end
  #   end
  #   shared_examples 'nonambiguous organization' do
  #     it "should detect current organization" do
  #       controller.should be_current_organization
  #     end
  #     it "should find current organization" do
  #       controller.current_organization.should == organization
  #     end
  #   end

  #   shared_examples 'ambiguous employee' do
  #     it "should not detect current employee" do
  #       controller.should_not be_current_employee
  #     end
  #     it "should not find current employee" do
  #       controller.current_employee.should be_blank
  #     end
  #   end
  #   shared_examples 'ambiguous account' do
  #     it "should not detect current account" do
  #       controller.should_not be_current_account
  #     end
  #     it "should not find current account" do
  #       controller.current_account.should be_blank
  #     end
  #   end
  #   shared_examples 'ambiguous organization' do
  #     it "should not detect current organization" do
  #       controller.should_not be_current_organization
  #     end
  #     it "should not find current organization" do
  #       controller.current_organization.should be_blank
  #     end
  #   end

  #   context 'having params' do
  #     before :each do
  #       controller.stub(:params).and_return(params)
  #     end

  #     context "with controller accounts and numeric id" do
  #       let(:params) { {controller: 'accounts', id: 23} }
  #       let(:user_accounts) { [account] }

  #       before(:each) do
  #         possibilities = mock 'relation', find: account
  #         user.should_receive(:accounts).and_return(possibilities)
  #       end

  #       it "should set current_account" do
  #         controller.current_account.should == account
  #       end

  #       it "does not set current_membership" do
  #         controller.current_membership.should be_nil
  #       end
  #     end

  #     context "with numeric account_id" do
  #       let(:params) { {account_id: 23} }
  #       let(:user_accounts) { [account] }
  #       before(:each) do
  #         user.should_receive(:accounts).and_return(user_accounts)
  #         user_accounts.should_receive(:find).with(23).and_return(account)
  #       end

  #       it "should set current_account" do
  #         controller.current_account.should == account
  #       end

  #       it "does not set current_membership" do
  #         controller.current_membership.should be_nil
  #       end
  #     end

  #     context "with controller organizations, numeric id and detected account" do
  #       let(:params) { {controller: 'organizations', id: 77} }
  #       before(:each) do
  #         controller.stub(:current_account).and_return(account)
  #         possibilities = mock 'relation', find: organization
  #         user.should_receive(:organizations_for).with(account).and_return(possibilities)
  #         user.should_receive(:employee_for_account).with(account).and_return(employee)
  #       end
  #       it "should provide current_organization" do
  #         controller.current_organization.should == organization
  #       end

  #       it "sets current_membership" do
  #         controller.current_membership.should_not be_nil
  #       end
  #     end

  #     context "with numeric organization_id and detected account" do
  #       let(:params) { {organization_id: 77} }
  #       it "should provide current_organization" do
  #         controller.stub(:current_account).and_return(account)
  #         possibilities = mock 'relation', find: organization
  #         user.should_receive(:organizations_for).with(account).and_return(possibilities)
  #         controller.current_organization.should == organization
  #       end
  #     end

  #   end

  #   context 'without direct params (dashboard)' do

  #     before :each do
  #       controller.stub(:params).and_return({})
  #     end

  #     let(:user)         { create :user }
  #     let(:account)      { create :account }
  #     let(:organization) { create :organization, account: account }
  #     let(:membership)   { create :membership, employee: employee, organization: organization }
  #     let(:employee)     { create role, account: account, user: user }

  #     context "not signed in" do
  #       let(:role)  { :employee }
  #       before :each do
  #         controller.stub(:user_signed_in? => false, current_user: nil)
  #       end

  #       it_should_behave_like 'ambiguous employee'
  #       it_should_behave_like 'ambiguous account'
  #       it_should_behave_like 'ambiguous organization'
  #     end

  #     context "owning one account" do
  #       let(:role)  { :employee_owner }
  #       before(:each)    { [employee, organization].each {|x| x.should be_persisted } }

  #       it_should_behave_like 'nonambiguous employee'
  #       it_should_behave_like 'nonambiguous account'
  #       it_should_behave_like 'nonambiguous organization'
  #     end

  #     context "member in one organization" do
  #       let(:role)     { :employee }
  #       before(:each)  { membership.should be_persisted }

  #       it_should_behave_like 'nonambiguous employee'
  #       it_should_behave_like 'nonambiguous account'
  #       it_should_behave_like 'nonambiguous organization'
  #     end

  #     context "member in multiple organizations of same account" do
  #       let(:role)               { :employee }
  #       let(:other_organization) { create :organization, account: account } # <<<<<<<<<
  #       let(:other_membership)   { create :membership, employee: employee, organization: other_organization }
  #       before(:each)            { membership.should be_persisted }
  #       before(:each)            { other_membership.should be_persisted }

  #       it_should_behave_like 'nonambiguous employee'
  #       it_should_behave_like 'ambiguous organization'
  #     end

  #     context "member in multiple organization of different accounts" do
  #       let(:role)               { :employee }
  #       let(:other_account)      { create :account }
  #       let(:other_organization) { create :organization, account: other_account } # <<<<<<<<<
  #       let(:other_membership)   { create :membership, employee: employee, organization: other_organization }
  #       before(:each)            { membership.should be_persisted }
  #       before(:each)            { other_membership.should be_persisted }

  #       it_should_behave_like 'nonambiguous employee'
  #       it_should_behave_like 'ambiguous organization'
  #     end

  #     context "owner employee of one account, member in another" do
  #       let(:role)               { :employee_owner }
  #       let(:other_account)      { create :account }
  #       let(:other_employee)     { create :employee, account: other_account, user: user }
  #       let(:other_organization) { create :organization, account: other_account }
  #       let(:other_membership)   { create :membership, employee: other_employee, organization: other_organization }
  #       let(:membership)         { nil }
  #       before(:each)            { [employee, organization, other_membership].each {|x| x.should be_persisted } }

  #       it_should_behave_like 'ambiguous employee'
  #       it_should_behave_like 'ambiguous account'
  #       it_should_behave_like 'ambiguous organization'
  #     end

  #   end
  # end
end
