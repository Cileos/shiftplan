class FeedsController < TokenAuthorizedController
  respond_to :ics

  def upcoming
    @schedulings = current_user.schedulings.upcoming
  end
end
