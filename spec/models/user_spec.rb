require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before(:each) do
    @user = User.new
  end

  describe "associations" do
    it "should be member of many accounts" do
      @user.should have_many(:memberships)
      @user.should have_many(:accounts)
    end
  end
end
