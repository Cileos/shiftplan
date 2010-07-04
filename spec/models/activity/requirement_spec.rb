require File.expand_path('../../../spec_helper', __FILE__)

describe 'Requirement activities' do
  before do
    Activity.session_timeout = false

    # FIXME: devise issues
    # @user = User.make
    @user = User.new(:name => 'Fritz Thielemann', :email => 'fritz@thielemann.de', :password => 'oracle')
    @user.skip_confirmation!
    @user.save!

    @account = Account.create!(:name  => 'Cileos UG', :subdomain => 'cileos', :admin => @user)

    @shift = Shift.make
    @qualification = Qualification.make

    ActiveRecord::Observer.enable_observers

    Thread.current[:user] = @user
    Thread.current[:account] = @account

    @requirement = Requirement.create(:shift => @shift, :qualification => @qualification)
  end

  after do
    ActiveRecord::Observer.disable_observers
  end

  describe 'logging' do
    it 'logs a creation activity' do
      activity = Activity.first
      activity.action.should    == 'update'
      activity.object.should    == @shift
      activity.user.should      == @user
      activity.user_name.should == @user.name
      activity.account.should   == @account
      activity.aggregated_at.should be_nil

      activity.alterations.should == {
        :to => {
          :requirements => [@qualification.name]
        }
      }
    end

    it 'logs a creation activity for a requirement without a qualification' do
      Activity.delete_all

      @requirement = Requirement.create(:shift => @shift)

      activity = Activity.first
      activity.action.should    == 'update'
      activity.object.should    == @shift
      activity.user.should      == @user
      activity.user_name.should == @user.name
      activity.account.should   == @account
      activity.aggregated_at.should be_nil

      activity.alterations.should == {
        :to => {
          :requirements => [@qualification.name, '[undefined]']
        }
      }
    end

    it 'logs a destroy activity' do
      Activity.delete_all

      @requirement.destroy

      activity = Activity.first
      activity.action.should    == 'update'
      activity.object.should    == @shift
      activity.user.should      == @user
      activity.user_name.should == @user.name
      activity.account.should   == @account
      activity.aggregated_at.should be_nil

      activity.alterations.should == {
        :to => {
          :requirements => []
        }
      }
    end
  end

  # describe 'aggregation' do
  #   it 'aggregates a create and a destroy activity by deleting all of them' do
  #     shift = Shift.make
  #     requirement = Requirement.make
  #     qualification = requirement.requirement.qualification
  #     shift.requirements << requirement.requirement
  #
  #     Activity.log('create', requirement, @user)
  #
  #     requirement.destroy
  #     Activity.log('destroy', requirement, @user)
  #
  #     Activity.aggregate!
  #     Activity.count.should == 0
  #   end
  # end
end