class Post < ActiveRecord::Base
  acts_as_commentable

  belongs_to :blog
  belongs_to :author, class_name: Employee
  has_many :comments, as: :commentable, order: :created_at

  validates_presence_of :title, :blog, :body, :author, :published_at

  before_validation :set_published_at, on: :create

  def organization
    blog.organization
  end

  protected

  def set_published_at
    self.published_at = Time.now
  end
end

PostDecorator
