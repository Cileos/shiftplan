module TutorialHelper
  def chapters_array_as_json(chapters)
    ActiveModel::ArraySerializer.new(chapters, each_serializer: Tutorial::ChapterSerializer).to_json
  end
end
