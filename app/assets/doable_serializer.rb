class DoableSerializer < ActiveModel::Serializer
  attributes :id, :name, :due_at, :done?
end
