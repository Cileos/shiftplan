class Requirement < ActiveRecord::Base
  belongs_to :shift
  belongs_to :qualification

  has_one :assignment
  has_one :assignee, :through => :assignment, :class_name => 'Employee'

  # validates_presence_of :shift_id,         :if => lambda { |record| record.shift.nil? }
  # TODO can be "any", so this can be nil
  # validates_presence_of :qualification_id, :if => lambda { |record| record.qualification.nil? }

  delegate :day, :start, :end, :to => :shift

  def qualified_employee_ids
    @qualified_employee_ids ||= Employee.for_qualification(qualification, :select => 'employees.id').map(&:id)
  end

  def fulfilled?
    !!assignment
  end
  
  def copy_from(other, options = {})
    self.assignment = other.assignment.clone if other.assignment
  end
  
  def clone(options)
    clone = super()
    clone.shift = nil
    clone.copy_from(self, options) if Array(options[:copy]).include?('assignments')
    clone
  end
end
