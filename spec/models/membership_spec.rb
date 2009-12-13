require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Membership do
  before(:each) do
    @membership = Membership.make
  end

  describe "associations" do
    it "should reference a user" do
      @membership.should belong_to(:user)
    end

    it "should reference an account" do
      @membership.should belong_to(:account)
    end
  end
end
