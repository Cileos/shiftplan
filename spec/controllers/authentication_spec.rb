require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# Note: This is actually a test for the Authentication mixin

describe AccountsController do
  before(:each) do
    @user = User.create!(:email => 'fritz@thielemann.de', :password => 'foo', :password_confirmation => 'foo')
  end

  describe "instance methods" do
    describe "#current_user=" do
      it "should set the given user as the current user" do
        controller.current_user = @user
        controller.instance_variable_get(:@_current_user).should == @user
      end
    end

    describe "#current_user" do
      it "should fetch the current user from the instance variable if already set" do
        controller.instance_variable_set(:@_current_user, @user)
        controller.current_user.should == @user
      end

      it "should set the current user from a cookie"
    end

    describe "#signed_in?" do
      it "should return false if no current user is set" do
        controller.signed_in?.should be_false
      end

      it "should return true if current user is set" do
        controller.current_user = @user
        controller.signed_in?.should be_true
      end
    end

    describe "#signed_out?" do
      it "should return true if no current user is set" do
        controller.signed_out?.should be_true
      end

      it "should return false if current user is set" do
        controller.current_user = @user
        controller.signed_out?.should be_false
      end
    end

    describe "#sign_in" do
      it "should sign in a given user" do
        pending # FIXME cookies in rspec?
        controller.sign_in(@user)
        controller.current_user.should == @user
      end

      it "should do nothing if a non-user object is given" do
        lambda { controller.sign_in(Object.new) }.should_not change(controller, :current_user)
      end

      it "should do nothing if no user is given" do
        lambda { controller.sign_in(nil) }.should_not change(controller, :current_user)
      end
    end

    describe "#sign_out" do
      before(:each) do
        controller.current_user = @user
      end

      it "should sign out the current user" do
        pending # FIXME cookies in rspec?
        controller.sign_out
        controller.current_user.should be_nil
      end
    end

    describe "#authenticate" do
      it "should do nothing if user is signed in" do
        controller.current_user = @user
        controller.should_not_receive(:deny_access)
        controller.send(:authenticate)
      end

      it "should deny access if user is not signed in" do
        controller.current_user = nil
        controller.should_receive(:deny_access)
        controller.send(:authenticate)
      end
    end

    describe "#deny_access" do
      before(:each) do
        AccountsController.before_filter(:deny_access)
      end

      it "should redirect the user to the login form" do
        controller.should_receive(:redirect_to)
        get 'new'
      end

      it "should set an error message if given"

      it "should store the current location as the return url" do
        get 'new'
        session[:return_to].should == '/accounts/new'
      end
    end

    describe "#redirect_back_or" do
      before(:each) do
        session[:return_to] = 'foo'
      end

      it "should use the return_to parameter" do
        controller.should_receive(:redirect_to).with('foo')
        controller.send(:redirect_back_or, 'bar')
      end

      it "should use the given default if no return_to parameter is set" do
        session[:return_to] = nil
        controller.should_receive(:redirect_to).with('bar')
        controller.send(:redirect_back_or, 'bar')
      end
    end

    describe "#clear_return_to" do
      it "should clear the return_to parameter from the session" do
        session[:return_to] = 'foo'
        controller.send(:clear_return_to)
        session[:return_to].should be_blank
      end
    end

    describe "#return_to" do
      before(:each) do
        session[:return_to] = 'foo'
        controller.params[:return_to]  = 'bar' # wtf?
      end

      it "should return the return_to parameter from the session if set" do
        controller.send(:return_to).should == 'foo'
      end

      it "should return the return_to parameter from the params if no session parameter is set" do
        session[:return_to] = nil
        controller.send(:return_to).should == 'bar'
      end
    end
  end
end