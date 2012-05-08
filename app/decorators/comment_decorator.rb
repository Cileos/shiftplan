class CommentDecorator < ApplicationDecorator
  decorates :comment

  def update_parent
    parent = comment.parent || raise(ArgumentError, 'comment has no parent')
    select(parent).replace_with item(parent)
  end

  def append_to_comments_tab(commentable)
    page.select("#tab_comments_#{commentable.id} ul.comments").append item
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
