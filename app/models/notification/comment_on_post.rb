class Notification::CommentOnPost < Notification::Comment

  def self.mailer_class
    PostNotificationMailer
  end

  def self.mailer_action
    :new_comment
  end

  def post
    comment.commentable
  end

  def subject
    t(:'subjects.comment_on_post', name: comment.author_name)
  end


  def introductory_text
    t(:'introductory_texts.comment_on_post', author_name: comment.author_name, employee_name: scheduling.employee.name,
      date: I18n.l(comment.created_at, format: :tiny), quickie: scheduling.quickie)
  end
end

class Notification::CommentOnPostOfEmployee < Notification::CommentOnPost
  def subject
    t(:'subjects.comment_on_post_of_employee', name: comment.author_name)
  end

  def introductory_text
    t(:'introductory_texts.comment_on_post_of_employee', author_name: comment.author_name, post_title: post.title,
      date: I18n.l(comment.created_at, format: :tiny))
  end
end

class Notification::CommentOnPostForCommenter < Notification::CommentOnPost
  def subject
    t(:'subjects.comment_on_post_for_commenter', name: comment.author_name)
  end

  def introductory_text
    t(:'introductory_texts.comment_on_post_for_commenter', author_name: comment.author_name, post_title: post.title,
      date: I18n.l(comment.created_at, format: :tiny))
  end
end
