require "tutorial/engine"

module Tutorial
  autoload :Controller, 'tutorial/controller'
  autoload :ChapterSerializer, 'tutorial/chapter_serializer'

  def self.define_chapter(*args, &block)
    Rails.logger.debug { "defining chapter: #{args.first}" }
    Tutorial::Chapter.define(*args, &block)
  end
end
