class NotificationsController < InheritedResources::Base
  actions :index

  defaults resource_class: Notification::Base,
    collection_name: 'notifications',
    instance_name: 'notification'

  load_and_authorize_resource class: Notification::Base

  before_filter :reset_new_notifications_count_for_user

  respond_to :js, :html

  protected

  def begin_of_association_chain
    current_user
  end

  def end_of_association_chain
    super.default_sorting.page(params[:page]).per(30)
  end

  def reset_new_notifications_count_for_user
    current_user.new_notifications_count = 0
    current_user.save!
  end
end
