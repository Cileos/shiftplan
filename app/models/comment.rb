class Comment < ActiveRecord::Base
  acts_as_nested_set :scope => [:commentable_id, :commentable_type]

  validates_presence_of :body
  validates_presence_of :employee

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  belongs_to :commentable, :polymorphic => true
  belongs_to :employee

  after_create :send_notifications

  # Helper class method that allows you to build a comment
  # by passing a commentable object, a employee_id, and comment text
  # example in readme
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

  # Helper class method to lookup all comments assigned
  # to all commentable types for a given employee.
  scope :find_comments_by_employee, lambda { |employee|
    where(:employee_id => employee.id).order('created_at DESC')
  }

  # Helper class method to look up all comments for
  # commentable class name and commentable id.
  scope :find_comments_for_commentable, lambda { |commentable_str, commentable_id|
    where(:commentable_type => commentable_str.to_s, :commentable_id => commentable_id).order('created_at DESC')
  }

  # Helper class method to look up a commentable object
  # given the commentable class name and id
  def self.find_commentable(commentable_str, commentable_id)
    commentable_str.constantize.find(commentable_id)
  end

  protected

  def send_notifications
    return true unless commentable_type == 'Post'
    notification_recipients.each do |e|
      PostNotificationMailer.new_comment(self, e).deliver
    end
  end

  def notification_recipients
    post = commentable
    post.organization.employees.select do |e|
      e.user.present? && employee != e && (post.author == e || post.commenters.include?(e))
    end
  end
end
