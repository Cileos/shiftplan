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
    describe ".authenticate" do
      before(:each) do
        @user = User.make(:email => 'fritz@thielemann.de', :password => 'foo', :password_confirmation => 'foo')
      end

      it "should not authenticate a user with a non-existent email" do
        User.authenticate('sven@fuchs.de', 'bar').should be_nil
      end

      it "should not authenticate a user with a wrong password" do
        User.authenticate('fritz@thielemann.de', 'bar').should be_nil
      end

      it "should authenticate a user with a correct password" do
        User.authenticate('fritz@thielemann.de', 'foo').should == @user
      end
    end
  end

  describe "instance methods" do
    describe "#authenticated?" do
      before(:each) do
        @user.encrypted_password = @user.send(:encrypt, 'foo')
      end

      it "should return true if the given password is correct" do
        @user.authenticated?('foo').should be_true
      end

      it "should return false if the given password is incorrect" do
        @user.authenticated?('bar').should be_false
      end
    end

    describe "#remember_me" do
      it "should set a remember token" do
        lambda { @user.remember_me }.should change(@user, :remember_token)
        @user.remember_token.should_not be_blank
      end
    end

    describe "#confirm_email" do
      it "should set the email address to be confirmed" do
        @user.confirm_email
        @user.email_confirmed.should be_true
      end
    end

    describe "#forgot_password" do
      it "should generate a fresh confirmation token" do
        lambda { @user.send(:forgot_password) }.should change(@user, :confirmation_token)
        @user.confirmation_token.should_not be_blank
      end
    end

    describe "#encrypt_password" do
      before(:each) do
        @user.password = 'foo'
      end

      it "should encrypt the user's password" do
        @user.send(:encrypt_password)
        @user.encrypted_password.should_not be_blank
      end

      it "should not encrypt the user's password if no password is set" do
        @user.password = nil
        @user.send(:encrypt_password)
        @user.encrypted_password.should be_blank
      end
    end

    describe "#initialize_salt" do
      it "should set a salt for a new user record" do
        lambda { @user.send(:initialize_salt) }.should change(@user, :salt)
        @user.salt.should_not be_blank
      end

      it "should not set a salt for an existing user record" do
        @user.stub!(:new_record?).and_return(false)
        lambda { @user.send(:initialize_salt) }.should_not change(@user, :salt)
      end
    end

    describe "#generate_confirmation_token" do
      it "should generate a new confirmation token" do
        lambda { @user.send(:generate_confirmation_token) }.should change(@user, :confirmation_token)
        @user.confirmation_token.should_not be_blank
      end
    end

    describe "#initialize_confirmation_token" do
      it "should set a confirmation token for a new user record" do
        lambda { @user.send(:initialize_confirmation_token) }.should change(@user, :confirmation_token)
        @user.confirmation_token.should_not be_blank
      end

      it "should not set a confirmation token for an existing user record" do
        @user.stub!(:new_record?).and_return(false)
        lambda { @user.send(:initialize_confirmation_token) }.should_not change(@user, :confirmation_token)
      end
    end
  end
end
