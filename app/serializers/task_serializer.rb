class TaskSerializer < DoableSerializer
  attribute :milestone_id # actually only needed for the TaskController#inject_milestone_id_into_params
end
