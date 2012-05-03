class Post < ActiveRecord::Base
  acts_as_commentable

  belongs_to :blog
  belongs_to :author, class_name: Employee
  has_many :comments, as: :commentable, order: :created_at

  validates_presence_of :title, :blog, :body, :author, :published_at

  before_validation :set_published_at, on: :create
  after_create :send_notifications

  def organization
    blog.organization
  end

  def commenters
    comments.map &:employee
  end

  protected

  def set_published_at
    self.published_at = Time.now
  end

  def send_notifications
    organization.employees.select {|e| e.user.present? && self.author != e }.each do |employee|
      PostNotificationMailer.new_post(self, employee).deliver
    end
  end
end

PostDecorator
