class Assignment < ActiveRecord::Base
  belongs_to :requirement
  belongs_to :assignee, :class_name => 'Employee'
end
