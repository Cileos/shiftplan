class Comment < ActiveRecord::Base
  acts_as_nested_set :scope => [:commentable_id, :commentable_type]

  validates_presence_of :body
  validates_presence_of :employee

  # TODO check for valid parent_id

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  belongs_to :commentable, polymorphic: true
  belongs_to :employee

  after_commit :create_notifications, on: :create
  after_create  :increment_counter
  after_destroy :decrement_counter


  # builds a comment by passing a commentable object, a user_id, and comment
  # text.
  def self.build_from(obj, employee, attributes)
    new.tap do |comment|
      comment.attributes       = attributes
      comment.commentable_id   = obj.id
      comment.commentable_type = obj.class.name
      comment.employee         = employee
    end
  end

  #helper method to check if a comment has children
  def has_children?
    self.children.size > 0
  end

  def is_answer?
    parent.present?
  end

  def author
    employee
  end

  def author_name
    author.name
  end

  private

  def increment_counter
    update_counter 1
  end

  def decrement_counter
    update_counter -1
  end

  # updates counter cache of associated model if it has a column for it
  def update_counter(delta=0)
    klass = commentable_type.constantize
    counter_name = "comments_count"
    if klass.column_names.include?(counter_name)
      klass.update_counters(commentable_id, counter_name => delta)
    end
  end

  protected

  def create_notifications
    Notification.create_for(self)
  end
end

CommentDecorator
