class Comment < ActiveRecord::Base
  acts_as_nested_set :scope => [:commentable_id, :commentable_type]
  
  validates_presence_of :body
  validates_presence_of :employee
  
  # NOTE: install the acts_as_votable plugin if you 
  # want user to vote on the quality of comments.
  #acts_as_voteable
  
  belongs_to :employee

  belongs_to :commentable, polymorphic: true
  
  # Helper class method that allows you to build a comment
  # by passing a commentable object, a user_id, and comment text
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
end
