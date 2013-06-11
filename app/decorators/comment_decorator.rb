class CommentDecorator < RecordDecorator
  decorates :comment

  def selector_for(comment, *a)
    case comment
    when Comment
      '#' + h.dom_id(comment)
    else
      super
    end
  end

  private
  def item(c=comment)
    h.render('comments/item', comment: c)
  end
end
