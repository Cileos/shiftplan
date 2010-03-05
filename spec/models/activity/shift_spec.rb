require File.expand_path('../../../spec_helper', __FILE__)

describe 'Shift activities' do
  before(:each) do
    Activity.session_timeout = false

    @user = User.make
    @plan = Plan.make
    @qualification = Qualification.make

    @shift = Shift.make_unsaved(:plan => @plan)
    @shift.requirements.build(:qualification => @qualification)

    ActiveRecord::Observer.enable_observers
    Thread.current[:user] = @user
    @shift.save!
  end
  
  after(:each) do
    ActiveRecord::Observer.disable_observers
  end

  describe 'logging' do
    it 'logs a creation activity' do
      Activity.count.should == 1

      activity = Activity.first
      activity.action.should    == 'create'
      activity.object.should    == @shift
      activity.user.should      == @user
      activity.user_name.should == @user.name
      activity.aggregated_at.should be_nil

      activity.changes[:to].should == {
        :start => @shift.start,
        :end   => @shift.end,
        :plan  => @shift.plan.name,
        :workplace => @shift.workplace.name,
        :requirements => [@qualification.name]
      }
    end

    it 'logs a changed start/end time to an update activity' do
      Activity.delete_all

      @shift.start += 1.hour
      @shift.end   += 1.hour
      @shift.save!

      Activity.count.should == 1

      activity = Activity.first
      activity.action.should  == 'update'
      activity.changes.should == {
        :from => { :start => @shift.start - 1.hour, :end => @shift.end - 1.hour },
        :to   => { :start => @shift.start, :end => @shift.end },
      }
    end

    it 'logs a new requirement to an update activity' do
      Activity.delete_all

      @shift.requirements << Requirement.new(:qualification => @qualification)

      Activity.count.should == 1

      activity = Activity.first
      activity.action.should == 'update'
      activity.changes.should == {
        :from => {},
        :to   => { :requirements => [@qualification.name, @qualification.name] }
      }
    end

    it 'logs a destroy activity' do
      Activity.delete_all

      @shift.destroy

      Activity.count.should == 1

      activity = Activity.first
      activity.action.should == 'destroy'
      activity.changes[:to].should == {
        :start => @shift.start,
        :end   => @shift.end,
        :plan  => @shift.plan.name,
        :workplace => @shift.workplace.name
      }
    end
  end

  describe 'aggregation' do
    it 'aggregates a create and two update activities' do
      @shift.start += 1.hour
      @shift.save!

      @shift.requirements << Requirement.new(:qualification => @qualification)

      Activity.aggregate!
      Activity.count.should == 1

      activity = Activity.first

      activity.action.should == 'create'
      activity.started_at.should_not be_nil
      activity.finished_at.should_not be_nil
      activity.aggregated_at.should_not be_nil

      activity.changes.should == {
        :start => @shift.start,
        :end   => @shift.end,
        :plan  => @shift.plan.name,
        :workplace => @shift.workplace.name,
        :requirements => [@qualification.name, @qualification.name]
      }
    end

    it 'aggregates three update activities' do
      Activity.delete_all

      @shift.start += 1.hour
      @shift.save!

      @shift.end += 1.hour
      @shift.save!

      @shift.requirements << Requirement.new(:qualification => @qualification)

      Activity.aggregate!

      Activity.count.should == 1

      activity = Activity.first
      activity.action.should == 'update'
      activity.started_at.should_not be_nil
      activity.finished_at.should_not be_nil
      activity.aggregated_at.should_not be_nil

      activity.changes.should == {
        :start => @shift.start,
        :end   => @shift.end,
        :requirements => [@qualification.name, @qualification.name]
      }
    end

    it 'aggregates two update and a destroy activity' do
      Activity.delete_all

      @shift.start += 1.hour
      @shift.save!

      @shift.end += 1.hour
      @shift.save!

      @shift.destroy

      Activity.aggregate!
      Activity.count.should == 1

      activity = Activity.first

      activity.action.should == 'destroy'
      activity.started_at.should_not be_nil
      activity.finished_at.should_not be_nil
      activity.aggregated_at.should_not be_nil

      activity.changes.should == {
        :start => @shift.start,
        :end   => @shift.end,
        :plan  => @shift.plan.name,
        :workplace => @shift.workplace.name
      }
    end

    it 'aggregates a create, an update and a destroy activity by deleting all of them' do
      @shift.start += 1.hour
      @shift.save!

      @shift.destroy

      Activity.aggregate!
      Activity.count.should == 0
    end
  end
end