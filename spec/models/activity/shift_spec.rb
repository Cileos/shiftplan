require File.expand_path('../../../spec_helper', __FILE__)

describe 'Shift activities' do
  before do
    @user = User.make
  end

  describe 'logging' do
    it 'logs a creation activity' do
      shift = Shift.make
      shift.initialize_dirty_associations

      shift.requirements << Requirement.make
      Activity.log('create', shift, @user)

      activity = Activity.first
      qualification = shift.requirements.first.qualification

      activity.action.should    == 'create'
      activity.object.should    == shift
      activity.user.should      == @user
      activity.user_name.should == @user.name
      activity.aggregated_at.should be_nil

      activity.changes[:to].should == {
        :start => shift.start,
        :end   => shift.end,
        :plan  => shift.plan.name,
        :workplace => shift.workplace.name,
        :requirements => [qualification.name]
      }
    end

    it 'logs a changed start/end time to an update activity' do
      shift = Shift.make
      shift.initialize_dirty_associations

      shift.start += 1.hour
      shift.end   += 1.hour
      Activity.log('update', shift, @user)

      activity = Activity.first

      activity.action.should  == 'update'
      activity.changes.should == {
        :from => { :start => shift.start - 1.hour, :end => shift.end - 1.hour },
        :to   => { :start => shift.start, :end => shift.end },
      }
    end

    it 'logs a new requirement to an update activity' do
      shift = Shift.make
      shift.initialize_dirty_associations

      shift.requirements << Requirement.make
      Activity.log('update', shift, @user)

      activity = Activity.first
      qualification = shift.requirements.first.qualification

      activity.action.should == 'update'
      activity.changes.should == {
        :from => { :requirements => [] },
        :to   => { :requirements => [qualification.name] }
      }
    end

    it 'logs a destroy activity' do
      shift = Shift.make
      shift.initialize_dirty_associations

      shift.requirements << Requirement.make
      shift.destroy
      Activity.log('destroy', shift, @user)

      activity = Activity.first
      qualification = shift.requirements.first.qualification
      activity.action.should == 'destroy'
      activity.changes[:to].should == {
        :start => shift.start,
        :end   => shift.end,
        :plan  => shift.plan.name,
        :workplace => shift.workplace.name,
        :requirements => [qualification.name]
      }
    end
  end

  describe 'aggregation' do
    it 'aggregates a create and two update activities' do
      shift = Shift.make
      shift.initialize_dirty_associations
      Activity.log('create', shift, @user)

      shift.start += 1.hour
      Activity.log('update', shift, @user)

      shift.requirements << Requirement.make
      Activity.log('update', shift, @user)

      Activity.aggregate!
      Activity.count.should == 1

      activity = Activity.first
      qualification = shift.requirements.first.qualification

      activity.action.should == 'create'
      activity.started_at.should_not be_nil
      activity.finished_at.should_not be_nil
      activity.aggregated_at.should_not be_nil

      activity.changes.should == {
        :start => shift.start,
        :end   => shift.end,
        :plan  => shift.plan.name,
        :workplace => shift.workplace.name,
        :requirements => [qualification.name]
      }
    end

    it 'aggregates three update activities' do
      shift = Shift.make
      shift.initialize_dirty_associations

      shift.start += 1.hour
      Activity.log('update', shift, @user)

      shift.end += 1.hour
      Activity.log('update', shift, @user)

      shift.requirements << Requirement.make
      Activity.log('update', shift, @user)

      Activity.aggregate!
      Activity.count.should == 1

      activity = Activity.first
      qualification = shift.requirements.first.qualification

      activity.action.should == 'update'
      activity.started_at.should_not be_nil
      activity.finished_at.should_not be_nil
      activity.aggregated_at.should_not be_nil

      activity.changes.should == {
        :start => shift.start,
        :end   => shift.end,
        :requirements => [qualification.name]
      }
    end

    it 'aggregates two update and a destroy activity' do
      shift = Shift.make
      shift.initialize_dirty_associations

      shift.start += 1.hour
      Activity.log('update', shift, @user)

      shift.end += 1.hour
      Activity.log('update', shift, @user)

      shift.destroy
      Activity.log('destroy', shift, @user)

      Activity.aggregate!
      Activity.count.should == 1

      activity = Activity.first

      activity.action.should == 'destroy'
      activity.started_at.should_not be_nil
      activity.finished_at.should_not be_nil
      activity.aggregated_at.should_not be_nil

      activity.changes.should == {
        :start => shift.start,
        :end   => shift.end,
        :plan  => shift.plan.name,
        :workplace => shift.workplace.name
      }
    end

    it 'aggregates a create, an update and a destroy activity by deleting all of them' do
      shift = Shift.make
      shift.initialize_dirty_associations
      Activity.log('create', shift, @user)

      shift.start += 1.hour
      Activity.log('update', shift, @user)

      shift.destroy
      Activity.log('destroy', shift, @user)

      Activity.aggregate!
      Activity.count.should == 0
    end
  end
end