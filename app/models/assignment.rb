class Assignment < ActiveRecord::Base
  belongs_to :requirement
  belongs_to :assignee, :class_name => 'Employee'

  validates_presence_of :requirement_id, :if => lambda { |record| record.requirement.nil? }
  validates_presence_of :assignee_id,    :if => lambda { |record| record.assignee.nil? }
end
