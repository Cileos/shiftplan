require_dependency 'active_model_serializers'
module Tutorial
  class ChapterSerializer < ActiveModel::Serializer
    attributes :id,
               :hint,
               :title,
               :motivation,
               :instructions,
               :examples,
               :isDone

    def isDone
      object.done?
    end
  end

end
