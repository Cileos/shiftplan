class NotificationsController < InheritedResources::Base
  actions :index

  defaults resource_class: Notification::Base,
    collection_name: 'notifications',
    instance_name: 'notification'

  load_and_authorize_resource class: Notification::Base, except: :mark_as_seen

  skip_authorization_check only: :mark_as_seen
  before_filter :authorize_multiple, only: :mark_as_seen

  respond_to :js, :html

  def mark_as_seen
    seen_notifications.update_all(seen: true)
  end

  protected

  def begin_of_association_chain
    current_user
  end

  def end_of_association_chain
    super.default_sorting.page(params[:page]).per(30)
  end

  def seen_notifications
    @seen_notifications ||=  current_user.notifications.unseen.where(id: seen_notification_ids)
  end

  def seen_notification_ids
    params[:seen_notifications].split(',')
  end

  def authorize_multiple
    seen_notifications.each do |seen_notification|
      authorize! :update, seen_notification
    end
  end
end
