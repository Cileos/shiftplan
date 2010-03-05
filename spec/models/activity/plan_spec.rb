require File.expand_path('../../../spec_helper', __FILE__)

describe 'Plan activities' do
  before(:each) do
    Activity.session_timeout = false

    @user = User.make

    ActiveRecord::Observer.enable_observers
    Thread.current[:user] = @user
    @plan = Plan.make
  end
  
  after(:each) do
    ActiveRecord::Observer.disable_observers
  end

  describe 'logging' do
    it 'logs a creation activity' do
      activity = Activity.first
      activity.action.should    == 'create'
      activity.object.should    == @plan
      activity.user.should      == @user
      activity.user_name.should == @user.name
      activity.aggregated_at.should be_nil

      activity.changes[:to].should == {
        :name       => @plan.name,
        :start_date => @plan.start_date,
        :end_date   => @plan.end_date,
        :template   => @plan.template
      }
    end

    it 'logs a changed start/end time to an update activity' do
      Activity.delete_all

      @plan.start_date += 1.day
      @plan.save!
    
      activity = Activity.first
    
      activity.action.should  == 'update'
      activity.changes.should == {
        :from => { :start_date => @plan.start_date - 1.day },
        :to   => { :start_date => @plan.start_date }
      }
    end
    
    it 'logs a destroy activity' do
      Activity.delete_all

      @plan.destroy
      @plan.save!
    
      activity = Activity.first
      activity.action.should == 'destroy'
      activity.changes[:to].should == {
        :name       => @plan.name,
        :start_date => @plan.start_date,
        :end_date   => @plan.end_date,
        :template   => @plan.template
      }
    end
  end

  describe 'aggregation' do
    it 'aggregates a create and two update activities' do
      @plan.name = 'Plan 2'
      @plan.save!
  
      @plan.start_date += 1.day
      @plan.save!
  
      Activity.aggregate!
      Activity.count.should == 1
  
      activity = Activity.first
  
      activity.action.should == 'create'
      activity.started_at.should_not be_nil
      activity.finished_at.should_not be_nil
      activity.aggregated_at.should_not be_nil
  
      activity.changes.should == {
        :name       => @plan.name,
        :start_date => @plan.start_date,
        :end_date   => @plan.end_date,
        :template   => @plan.template
      }
    end
  
    it 'aggregates two update activities' do
      Activity.delete_all

      @plan.name = 'Plan 2'
      @plan.save!
  
      @plan.start_date += 1.day
      @plan.save!
  
      Activity.aggregate!
      Activity.count.should == 1
  
      activity = Activity.first

      activity.action.should == 'update'
      activity.started_at.should_not be_nil
      activity.finished_at.should_not be_nil
      activity.aggregated_at.should_not be_nil
  
      activity.changes.should == {
        :name       => @plan.name,
        :start_date => @plan.start_date,
      }
    end
  
    it 'aggregates two update and a destroy activity' do
      Activity.delete_all

      @plan.name = 'Plan 2'
      @plan.save!
  
      @plan.start_date += 1.day
      @plan.save!
  
      @plan.destroy
  
      Activity.aggregate!
      Activity.count.should == 1
  
      activity = Activity.first
  
      activity.action.should == 'destroy'
      activity.started_at.should_not be_nil
      activity.finished_at.should_not be_nil
      activity.aggregated_at.should_not be_nil
  
      activity.changes.should == {
        :name       => @plan.name,
        :start_date => @plan.start_date,
        :end_date   => @plan.end_date,
        :template   => @plan.template
      }
    end
  
    it 'aggregates a create, an update and a destroy activity by deleting all of them' do
      @plan.name = 'Plan 2'
      @plan.save!
  
      @plan.destroy

      Activity.aggregate!
      Activity.count.should == 0
    end
  end
end