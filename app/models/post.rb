class Post < ActiveRecord::Base
  acts_as_commentable

  belongs_to :blog
  belongs_to :author, class_name: Employee
  has_many :comments, as: :commentable, order: 'comments.lft, comments.id' # FIXME gets ALL comments, tree structure is ignored

  validates_presence_of :title, :blog, :body, :author, :published_at

  before_validation :set_published_at, on: :create
  after_commit :create_notifications, on: :create

  delegate :organization, to: :blog

  def commenters
    comments.map &:employee
  end

  protected

  def set_published_at
    self.published_at = Time.now
  end

  def create_notifications
    Notification.create_for(self)
  end
end

PostDecorator
