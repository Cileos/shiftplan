require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Account do
  before(:each) do
    @account = Account.new
  end

  describe "associations" do
    it "should have users" do
      @account.should have_many(:memberships)
      @account.should have_many(:users)
    end
  end
end
