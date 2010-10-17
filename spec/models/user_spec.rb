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

  describe "class methods" do
    describe ".find_for_authentication" do
      before(:each) do
        account = Account.make(:subdomain => 'cileos')
        @user = User.make(:email => 'fritz@thielemann.de', :accounts => [account])
      end

      it "should find a user with the given email and account subdomain" do
        User.find_for_authentication(:email => 'fritz@thielemann.de', :subdomain => 'cileos').should == @user
      end

      it "should find no user for a non-existent combination of email and account subdomain" do
        User.find_for_authentication(:email => 'clemens@railway.at',  :subdomain => 'cileos').should be_nil
        User.find_for_authentication(:email => 'fritz@thielemann.de', :subdomain => 'stadtverwaltung').should be_nil
      end
    end
  end

  describe "instance methods" do
    describe "#member_of?" do
      before(:each) do
        @user    = User.make
        @account = Account.make
      end

      it "should return true if the user is a member of the given account" do
        @user.update_attributes(:accounts => [@account])
        @user.should be_member_of(@account)
      end

      it "should return false if the user is not a member of the given account" do
        @user.update_attributes(:accounts => [])
        @user.should_not be_member_of(@account)
      end
    end
  end
end
