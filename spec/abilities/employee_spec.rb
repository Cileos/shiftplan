require 'spec_helper'
require "cancan/matchers"

describe "User" do
  subject { ability }
  let(:ability) { Ability.new(user) }

  context "when is a planner" do
    let(:user) { Factory(:planner) }
    let(:organization) { Factory(:organization, :planner => user) }
    
    context "for own organization" do
      it "should be able to read employees" do
        should be_able_to(:read, Factory(:employee, organization: organization))
      end
    
      it "should be able to update employees" do
        should be_able_to(:update, Factory(:employee, organization: organization))
      end
    
      it "should be able to create employees" do
        should be_able_to(:create, Factory.build(:employee, organization: organization))
      end
    
      it "should not be able to destroy employees" do
        should_not be_able_to(:destroy, Factory(:employee, organization: organization))
      end
    end
    
    context "for other organizations" do
      it "should not be able to read employees" do
        another_organization = Factory(:organization)
        should_not be_able_to(:read, Factory(:employee, organization: another_organization))
      end
    
      it "should not be able to update employees" do
        another_organization = Factory(:organization)
        should_not be_able_to(:update, Factory(:employee, organization: another_organization))
      end
    
      it "should not be able to create employees" do
        another_organization = Factory(:organization)
        should_not be_able_to(:create, Factory.build(:employee, organization: another_organization))
      end
    end

    it "should not be able to destroy employees for other organizations" do
      another_organization = Factory(:organization)        
      should_not be_able_to(:destroy, Factory(:employee, organization: another_organization))
    end
  end
end