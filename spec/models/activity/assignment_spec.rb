require File.expand_path('../../../spec_helper', __FILE__)

describe 'Assignment activities' do
  before do
    Activity.session_timeout = false

    # FIXME: devise issues
    # @user = User.make
    @user = User.new(:name => 'Fritz Thielemann', :email => 'fritz@thielemann.de', :password => 'oracle')
    @user.skip_confirmation!
    @user.save!

    @account = Account.create!(:name  => 'Cileos UG', :subdomain => 'cileos', :admin => @user)

    @shift = Shift.make
    @requirement = Requirement.make
    @employee = Employee.make
    @shift.requirements << @requirement

    ActiveRecord::Observer.enable_observers

    Thread.current[:user] = @user
    Thread.current[:account] = @account

    @assignment = Assignment.create(:requirement => @requirement, :assignee => @employee)
  end

  after do
    ActiveRecord::Observer.disable_observers
  end

  describe 'logging' do
    it 'logs a creation activity' do
      activity = Activity.first
      activity.action.should          == 'create'
      activity.activity_object.should == @assignment
      activity.user.should            == @user
      activity.user_name.should       == @user.name
      activity.account.should         == @account
      activity.aggregated_at.should be_nil

      activity.alterations.should == {
        :to => {
          :assignee => @assignment.assignee.full_name,
          :requirement => @requirement.qualification.name,
          :shift => { :plan => @shift.plan.name, :workplace => @shift.workplace.name, :start => @shift.start, :end => @shift.end }
        }
      }
    end

    it 'logs a destroy activity' do
      Activity.delete_all

      @assignment.destroy

      activity = Activity.first
      activity.action.should == 'destroy'

      activity.alterations.should == {
        :to => {
          :assignee => @assignment.assignee.full_name,
          :requirement => @requirement.qualification.name,
          :shift => { :plan => @shift.plan.name, :workplace => @shift.workplace.name, :start => @shift.start, :end => @shift.end }
        }
      }
    end
  end

  describe 'aggregation' do
    it 'aggregates a create and a destroy activity by deleting all of them' do
      @assignment.destroy

      Activity.aggregate!
      Activity.count.should == 0
    end
  end
end