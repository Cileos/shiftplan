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
    end
    let(:controller) { controller_class.new }

    let(:account) { mock 'Account' }
    let(:organization) { mock 'Organization' }

    context 'having params' do
      before :each do
        controller.stub(:params).and_return(params)
      end

      context "with numeric account_id" do
        let(:params) { {account_id: 23} }
        it "should set current_account" do
          Account.should_receive(:find).with(23).and_return(account)
          controller.set_current_account
          controller.current_account.should == account
        end
      end

      context "with numeric organization_id" do
        let(:params) { {organization_id: 23} }
        it "should provide current_organization" do
          Organization.should_receive(:find).with(23).and_return(organization)
          controller.current_organization.should == organization
        end
      end
    end

    context 'without direct params' do
      it "should set current employee from current account and user"
      it "should set current employee with first owner of user ??"
      it "should set current account from first owner of user ??"
    end
  end
end
