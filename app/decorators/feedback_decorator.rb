class FeedbackDecorator < ApplicationDecorator
  decorates :feedback

  def respond
    unless errors.empty?
      prepend_errors_for(feedback)
    else
      hide_modal
      update_flash
    end
  end
end
