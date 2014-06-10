class TutorialController < ActionController::Base
  layout 'ember'

  def index
    @chapters ||= Tutorial::Chapter.all(current_user)
  end

end
