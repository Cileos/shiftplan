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

    it "should have employees" do
      @account.should have_many(:employees)
    end

    it "should have workplaces" do
      @account.should have_many(:workplaces)
    end

    it "should have qualifications" do
      @account.should have_many(:qualifications)
    end

    it "should have plans" do
      @account.should have_many(:plans)
    end
  end

  describe "validations" do
    it "should require a name" do
      @account.should validate_presence_of(:name)
    end
  end

  describe "instance methods" do
    describe "#admin=" do # even if it's only temporary ...
      before(:each) do
        @account.name = 'Test account'
        admin = User.new(:email => 'fritz@thielemann.de', :password => 'oracle', :password_confirmation => 'oracle')
        admin.skip_confirmation!
        @account.admin = admin
        @account.save!

        @admin = @account.users.first
        @membership = @account.memberships.first
      end

      it "should set an account admin" do
        @admin.email.should == 'fritz@thielemann.de'
        @admin.confirmed_at.should_not be_nil
      end

      it "should create a membership" do
        @membership.admin.should be_true
        @membership.user.should == @admin
      end
    end
  end
end
