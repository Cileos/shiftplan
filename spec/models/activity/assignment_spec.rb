require File.expand_path('../../../spec_helper', __FILE__)

describe 'Assignment activities' do
  before do
    @user = User.make
  end

  describe 'logging' do
    it 'logs a creation activity' do
      shift = Shift.make
      assignment = Assignment.make
      qualification = assignment.requirement.qualification
      shift.requirements << assignment.requirement

      Activity.log('create', assignment, @user)

      activity = Activity.first
      activity.action.should    == 'create'
      activity.object.should    == assignment
      activity.user.should      == @user
      activity.user_name.should == @user.name
      activity.aggregated_at.should be_nil

      activity.changes[:to].should == {
        :assignee => assignment.assignee.full_name,
        :requirement => qualification.name,
        :shift => { :plan => shift.plan.name, :workplace => shift.workplace.name, :start => shift.start, :end => shift.end },
      }
    end

    it 'logs a destroy activity' do
      shift = Shift.make
      assignment = Assignment.make
      qualification = assignment.requirement.qualification
      shift.requirements << assignment.requirement

      assignment.destroy
      Activity.log('destroy', assignment, @user)
    
      activity = Activity.first
      activity.action.should == 'destroy'

      activity.changes[:to].should == {
        :assignee => assignment.assignee.full_name,
        :requirement => qualification.name,
        :shift => { :plan => shift.plan.name, :workplace => shift.workplace.name, :start => shift.start, :end => shift.end },
      }
    end
  end

  describe 'aggregation' do
    it 'aggregates a create and a destroy activity by deleting all of them' do
      shift = Shift.make
      assignment = Assignment.make
      qualification = assignment.requirement.qualification
      shift.requirements << assignment.requirement

      Activity.log('create', assignment, @user)
  
      assignment.destroy
      Activity.log('destroy', assignment, @user)
  
      Activity.aggregate!
      Activity.count.should == 0
    end
  end
end