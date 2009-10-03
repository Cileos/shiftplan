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

  describe "validations" do
    it "should require a name" do
      @account.should validate_presence_of(:name)
    end
  end
end
