class MilestoneSerializer < DoableSerializer
  has_many :tasks
  attribute :responsible_id # Employees are fetces separately
end
