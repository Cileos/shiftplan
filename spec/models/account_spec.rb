# encoding: UTF-8

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Account do
  before(:each) do
    @account = Account.make
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

    it "should have activities" do
      @account.should have_many(:activities)
    end
  end

  describe "validations" do
    it "should require a name" do
      @account.should validate_presence_of(:name)
    end

    it "should require a subdomain" do
      @account.should validate_presence_of(:subdomain)
    end

    it "should require a unique subdomain" do
      @account.should validate_uniqueness_of(:subdomain)
    end

    it "should require the subdomain to contain only alphanumeric characters and dashes" do
      valid_subdomains   = %w(foo foo1 foo-bar)
      invalid_subdomains = %w(foo_bar föö ba$)

      valid_subdomains.each do |subdomain|
        @account.subdomain = subdomain
        @account.valid?
        @account.errors[:subdomain].should be_empty
      end

      invalid_subdomains.each do |subdomain|
        @account.subdomain = subdomain
        @account.valid?
        @account.errors[:subdomain].should_not be_empty
      end
    end
  end

  describe "instance methods" do
    describe "#admin=" do # even if it's only temporary ...
      before(:each) do
        admin = User.new(:email => 'fritz@thielemann.de', :password => 'oracle', :password_confirmation => 'oracle')
        admin.skip_confirmation!

        @account = Account.make(:admin => admin)

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
