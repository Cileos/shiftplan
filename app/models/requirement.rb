class Requirement < ActiveRecord::Base
  belongs_to :shift
  belongs_to :qualification

  has_one :assignment
  has_one :assignee, :through => :assignment, :class_name => 'Employee'

  validates_presence_of :shift_id,         :if => lambda { |record| record.shift.nil? }
  # TODO can be "any", so this can be nil
  # validates_presence_of :qualification_id, :if => lambda { |record| record.qualification.nil? }

  def fulfilled?
    !!assignment
  end
end
