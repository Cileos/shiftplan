class NotificationsController < InheritedResources::Base
  actions :index

  defaults resource_class: Notification::Base,
    collection_name: 'notifications',
    instance_name: 'notification'

  load_and_authorize_resource class: Notification::Base, except: :mark_as_seen

  skip_authorization_check only: :mark_as_seen
  before_filter :authorize_multiple, only: :mark_as_seen

  before_filter :mark_all_on_index_page_as_seen, only: :index

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

  def mark_all_on_index_page_as_seen
    respond_to do |format|
      format.html do
        unseen_ids = collection.reject(&:seen?).map(&:id)
        if unseen_ids.present?
          current_user.notifications.where(id: unseen_ids).update_all(seen: true)
        end
      end
      format.js # user opens the hub: do nothing
    end
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
