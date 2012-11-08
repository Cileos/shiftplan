require 'spec_helper'

describe Organization do
  it "should need a name" do
    build(:organization, :name => nil).should be_invalid
  end

  describe "#other_employees" do
    let(:account) { create :account }
    let(:organization) { create :organization, account: account }
    let(:other_organization) { create(:organization, account: account) }
    let(:employee_homer) { create(:employee, first_name: 'Homer', account: account) }
    let(:employee_bart) { create(:employee, first_name: 'Bart', account: account) }

    context "for organization without any members" do
      it "should return all employees of the account" do
        other_organization.employees << employee_homer
        other_organization.employees << employee_bart

        organization.other_employees.should == [employee_bart, employee_homer]
      end
    end

    context "for organization with some members" do
      it "should return all employees of the account that are not members, yet" do
        organization.employees << employee_homer
        other_organization.employees << employee_homer
        other_organization.employees << employee_bart

        organization.other_employees.should == [employee_bart]
      end
    end
  end
end
