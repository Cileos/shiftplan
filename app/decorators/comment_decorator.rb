class CommentDecorator < RecordDecorator
  decorates :comment

  def update_parent
    parent = comment.parent || raise(ArgumentError, 'comment has no parent')
    select(parent).replace_with item(parent)
  end

  def append_to_comments_list(commentable)
    page.select("ul.comments##{h.dom_id(commentable, :comments)}").append item
  end

  def selector_for(comment, *a)
    case comment
    when Comment
      '#' + h.dom_id(comment)
    else
      super
    end
  end

  def reset_form
    page['comment_body'].val ''
    page['comment_parent_id'].val ''
  end

  private
  def item(c=comment)
    h.render('comments/item', comment: c)
  end
end
