class DoableSerializer < ApplicationSerializer
  attributes :id, :name, :due_at, :done?,
    :responsible_id # Employees are fetched separately
end
