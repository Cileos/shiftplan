require File.expand_path('../../../spec_helper', __FILE__)

describe 'Requirement activities' do
  before do
    @user = User.make
  end

  describe 'logging' do
    it 'logs a creation activity' do
      shift = Shift.make
      shift.initialize_dirty_associations
      requirement = Requirement.make
      requirements.shift = shift

      Activity.log('create', requirement, @user)

      activity = Activity.first
      activity.action.should    == 'update'
      activity.object.should    == shift
      activity.user.should      == @user
      activity.user_name.should == @user.name
      activity.aggregated_at.should be_nil

      activity.changes[:to].should == {
        :requirements => [requirement.qualification.name]
      }
    end

    it 'logs a destroy activity' do
      shift = Shift.make
      shift.initialize_dirty_associations
      requirement = Requirement.make
      requirements.shift = shift

      Activity.log('destroy', requirement, @user)

      activity = Activity.first
      activity.action.should    == 'update'
      activity.object.should    == shift
      activity.user.should      == @user
      activity.user_name.should == @user.name
      activity.aggregated_at.should be_nil

      activity.changes[:to].should == {
        :requirements => []
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