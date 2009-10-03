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

  describe "validations" do
    it "should require a unique valid email" do
      @user.should validate_presence_of(:email)
      @user.should validate_uniqueness_of(:email)
      # @user.should validate_format_of(:email, :with => /.+@.+\..+/)
    end

    it "should require a password" do
      @user.should validate_presence_of(:password)
      @user.should validate_confirmation_of(:password)
    end
  end
end
