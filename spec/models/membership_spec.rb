require 'spec_helper'

describe Membership do
  let(:user) { create :user }
  let(:account) { create :account }
  let(:employee) { create :employee, account: account }
  let(:organization) { create :organization, account: account }

  context "for employee already being a member of the organization" do
    before :each do
      create :membership, employee: employee, organization: organization
    end

    it "should not be valid" do
      m = build :membership, employee: employee, organization: organization
      m.should_not be_valid
    end
  end

  it 'builds successfully from factory' do
    build(:membership).should be_valid
  end

  it 'needs non-arbitrary role' do
    build(:membership, role: 'spaghettimonster').should_not be_valid
  end
end
