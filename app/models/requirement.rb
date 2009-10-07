class Requirement < ActiveRecord::Base
  belongs_to :shift
  belongs_to :qualification
  has_one :assignment
  has_one :assignee, :through => :assignment, :class_name => 'Employee'

  def fulfilled?
    !!assignment
  end
end
