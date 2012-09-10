class MilestoneSerializer < ActiveModel::Serializer
  attributes :id, :name, :due_at, :done?

end
