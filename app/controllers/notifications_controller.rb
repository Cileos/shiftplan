class NotificationsController < BaseController
  actions :index, :update

  respond_to :js, :html

  protected

  def begin_of_association_chain
    current_user
  end

  def end_of_association_chain
    super.default_sorting
  end
end
