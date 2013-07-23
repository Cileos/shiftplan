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
  let!(:organization_1)    { create(:organization, account: account_1) }
  let!(:organization_2)    { create(:organization, account: account_1) }
  let!(:membership_1)      do
    create(:membership, employee: employee_1, organization: organization_1)
  end
  let!(:membership_2)      do
    create(:membership, employee: employee_1, organization: organization_2)
  end
  let(:params)             {{}}

  before(:each) do
    controller_class.send :include, described_class
    controller.stub(:params).and_return(params)
    controller.stub(:current_user).and_return(user)
  end

  context "#current_account" do
    context "when logged in" do
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

        context "for a user with multiple accounts" do
          it "does not set the current account" do
            controller.current_account.should be_nil
          end
        end

        context "for a user with exactly one account" do
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

  context "#current_account?" do
    context "when controller has a current account" do
      before(:each) { controller.stub(:current_account).and_return(account_1) }

      it { controller.current_account?.should be_true }
    end
    context "when controller has no current account" do
      before(:each) { controller.stub(:current_account).and_return(nil) }

      it { controller.current_account?.should be_false }
    end
  end

  context "#current_organization" do

    context "with current account set" do
      before(:each) do
        controller.stub(:current_account).and_return(account_1)
      end

      context" with organization params" do
        context "when in the scope of an organization" do
          let(:params) { { controller: 'organizations', id: organization_1.id } }

          it "sets the current organization to organization specified in the params" do
            controller.current_organization.should == organization_1
          end
        end

        context "when in the subordinate scope of an organization" do
          let(:params) { { organization_id: organization_1.id } }

          it "sets the current organization to organization specified in the params" do
            controller.current_organization.should == organization_1
          end
        end
      end

      context "without organizations params" do
        context "for a user with multiple organizations" do
          it "does not set a current organization" do
            controller.current_organization.should be_nil
          end
        end

        context "for user with exactly one organization" do
          before(:each) do
            controller.current_user.stub(:organizations_for).and_return([organization_1])
          end
          it "does set the current organization to the organization of the user" do
            controller.current_organization.should == organization_1
          end
        end
      end

    end

    context "with no current account set" do
      # even with organizations params
      let(:params) { { controller: 'organizations', id: organization_1.id } }

      before(:each) { controller.stub(:current_account).and_return(nil) }

      it "does not set a current organization" do
        controller.current_organization.should be_nil
      end
    end

  end

  context "#current_organization?" do
    context "when controller has a current organization" do
      let!(:organization_1) { create(:organization, account: account_1) }

      before(:each) { controller.stub(:current_organization).and_return(organization_1) }

      it { controller.current_organization?.should be_true }
    end
    context "when controller has no current organization" do
      before(:each) { controller.stub(:current_organization).and_return(nil) }

      it { controller.current_organization?.should be_false }
    end
  end

  context "#current_employee" do
    context "when signed in and current account is set" do
      before(:each) { controller.stub(:current_account).and_return(account_1) }

      it "sets the current employee to the employee of the user for the account" do
        controller.current_employee.should == employee_1
      end

      it "sets the current employee on the current user" do
        controller.current_employee
        controller.current_user.current_employee.should == employee_1
      end
    end

    context "when not signed in" do
      before(:each) { controller.stub(:current_user).and_return(nil) }

      it "does not set the current employee" do
        controller.current_employee.should be_nil
      end
    end

    context "when current account is not set" do
      before(:each) { controller.stub(:current_account).and_return(nil) }

      it "does not set the current employee" do
        controller.current_employee.should be_nil
      end
    end
  end

  context "#current_employee?" do
    context "when controller has a current employee" do
      before(:each) { controller.stub(:current_employee).and_return(employee_1) }

      it { controller.current_employee?.should be_true }
    end
    context "when controller has no current employee" do
      before(:each) { controller.stub(:current_employee).and_return(nil) }

      it { controller.current_employee?.should be_false }
    end
  end

  context "#current_membership" do
    shared_examples :a_controller_without_a_current_membership do
      it "does not set the current membership" do
        controller.current_membership.should be_nil
      end
    end
    context "when user is signed in and the current account is set" do
      before(:each) { controller.stub(:current_account).and_return(account_1)}

      context "with organization params" do

        shared_examples :a_controller_with_a_current_membership do
          it "sets the current membership to the membership for the organization" do
            controller.current_membership.should == membership_1
          end
          it "set the current membership on the current user" do
            controller.current_membership
            controller.current_user.current_membership.should == membership_1
          end
        end

        context "when in the scope of an organization" do
          it_behaves_like :a_controller_with_a_current_membership do
            let(:params) { { controller: 'organizations', id: organization_1.id} }
          end
        end

        context "when in an subordinate scope of an organization" do
          it_behaves_like :a_controller_with_a_current_membership do
            let(:params) { { organization_id: organization_1.id} }
          end
        end
      end

      context "without organization params" do
        it_behaves_like :a_controller_without_a_current_membership
      end

    end

    context "when user is not signed in" do
      before(:each) { controller.stub(:current_user).and_return(nil)}

      it_behaves_like :a_controller_without_a_current_membership
    end

    context "when the current account is not set" do
      before(:each) { controller.stub(:current_account).and_return(nil)}

      it_behaves_like :a_controller_without_a_current_membership
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
