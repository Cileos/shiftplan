require 'activity'

class Assignment < ActiveRecord::Base
  belongs_to :requirement
  belongs_to :assignee, :class_name => 'Employee'

  validates_presence_of :requirement_id, :if => lambda { |record| record.requirement.nil? }
  validates_presence_of :assignee_id,    :if => lambda { |record| record.assignee.nil? }

  def log_create
    { :to => { :shift => log_shift, :requirement => requirement.qualification.name, :assignee => assignee.full_name } }
  end
  alias :log_destroy :log_create

  def log_shift
    shift = requirement.shift
    { :plan => shift.plan.name, :workplace => shift.workplace.name, :start => shift.start, :end => shift.end }
  end

  def log_update
    raise 'not relevant, should not be called'
  end
end
