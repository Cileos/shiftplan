require 'spec_helper'

describe Account do
  it "must have a name" do
    build(:account, name: nil).should_not be_valid
    build(:account, name: '' ).should_not be_valid
  end

  context "for new accounts" do
    it "must have a name" do
      build(:new_account, name: nil).should_not be_valid
      build(:new_account, name: '' ).should_not be_valid
    end
    it "must have an organization name" do
      build(:new_account, organization_name: nil).should_not be_valid
      build(:new_account, organization_name: '' ).should_not be_valid
    end
    it "must have a first name" do
      build(:new_account, first_name: nil).should_not be_valid
      build(:new_account, first_name: '' ).should_not be_valid
    end
    it "must have a last name" do
      build(:new_account, last_name: nil).should_not be_valid
      build(:new_account, last_name: '' ).should_not be_valid
    end
    it "must have a user id" do
      build(:new_account, user_id: nil).should_not be_valid
      build(:new_account, user_id: '' ).should_not be_valid
    end
  end
end
