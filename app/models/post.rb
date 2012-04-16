class Post < ActiveRecord::Base
  belongs_to :blog

  validates_presence_of :title, :blog, :context, :author, :published_at
end