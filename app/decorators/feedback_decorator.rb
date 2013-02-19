class FeedbackDecorator < RecordDecorator
  decorates :feedback

  def respond
    unless errors.empty?
      prepend_errors_for(feedback)
    else
      clear_modal
      update_flash
    end
  end
end
