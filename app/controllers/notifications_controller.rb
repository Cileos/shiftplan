class NotificationsController < InheritedResources::Base
  actions :index

  defaults resource_class: Notification::Base,
    collection_name: 'notifications',
    instance_name: 'notification'

  load_and_authorize_resource class: Notification::Base

  before_filter :mark_all_as_read

  respond_to :js, :html

  protected

  def begin_of_association_chain
    current_user
  end

  def end_of_association_chain
    super.default_sorting.page(params[:page]).per(30)
  end

  def mark_all_as_read
    current_user.notifications.update_all(seen: true)
  end
end
