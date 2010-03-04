require File.expand_path('../../../spec_helper', __FILE__)

describe 'Assignment activities' do
  before do
    @user = User.make
    @shift = Shift.make
    @requirement = Requirement.make
    @employee = Employee.make
    @shift.requirements << @requirement

    ActiveRecord::Observer.enable_observers

    @assignment = Assignment.create(:requirement => @requirement, :assignee => @employee)
  end

  after do
    ActiveRecord::Observer.disable_observers
  end

  describe 'logging' do
    it 'logs a creation activity' do
      activity = Activity.first
      activity.action.should    == 'create'
      activity.object.should    == @assignment
      activity.user.should      == @user
      activity.user_name.should == @user.name
      activity.aggregated_at.should be_nil

      activity.changes[:to].should == {
        :assignee => @assignment.assignee.full_name,
        :requirement => @requirement.qualification.name,
        :shift => { :plan => @shift.plan.name, :workplace => @shift.workplace.name, :start => @shift.start, :end => @shift.end },
      }
    end

    it 'logs a destroy activity' do
      Activity.delete_all
      
      @assignment.destroy

      activity = Activity.first
      activity.action.should == 'destroy'

      activity.changes[:to].should == {
        :assignee => @assignment.assignee.full_name,
        :requirement => @requirement.qualification.name,
        :shift => { :plan => @shift.plan.name, :workplace => @shift.workplace.name, :start => @shift.start, :end => @shift.end },
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