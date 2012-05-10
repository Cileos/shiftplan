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

  after_create :send_notifications

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


  protected

  def send_notifications
    if commentable_type == 'Post'
      notification_recipients_for_comment_on_post.each do |e|
        PostNotificationMailer.new_comment(self, e).deliver
      end
    elsif commentable_type == 'Scheduling'
      notification_recipients_for_comment_on_scheduling.each do |e|
        SchedulingNotificationMailer.new_comment(self, e).deliver
      end
    end
  end

  def notification_recipients_for_comment_on_scheduling
    scheduling = commentable
    organization = scheduling.organization
    (
      organization.owners +
      organization.planners +
      [scheduling.employee] + # sent mail to the employee of the scheduling
      scheduling.commenters - # sent mail to employees who commented the scheduling before
      [employee] # do not sent mail to commenter
    ).select { |e| e.user.present? }.uniq # do not try to sent mails to employees without a user/a mail address
  end

  def notification_recipients_for_comment_on_post
    post = commentable
    post.organization.employees.select do |e|
      e.user.present? && employee != e && (post.author == e || post.commenters.include?(e))
    end
  end
end

CommentDecorator
