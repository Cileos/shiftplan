class NotificationsController < InheritedResources::Base
  actions :index
  custom_actions resource: :read, collection: :multiple_read

  skip_authorization_check only: :multiple_read
  before_filter :authorize_multiple_read, only: :multiple_read

  defaults resource_class: Notification::Base,
    collection_name: 'notifications',
    instance_name: 'notification'

  load_and_authorize_resource class: Notification::Base

  respond_to :js, :html

  def read
    resource.read_at = Time.zone.now
    resource.save!
  end

  def multiple_read
    collection.readonly(false).each do |n|
      n.read_at = Time.zone.now
      n.save!
    end
  end

  protected

  def collection
    if params[:action] == 'multiple_read'
      notification_ids = params[:notifications].split(',')
      @notificatons ||=  super.where(id: notification_ids)
    else
      super
    end
  end

  def begin_of_association_chain
    current_user
  end

  def end_of_association_chain
    super.for_hub
  end

  def authorize_multiple_read
    collection.each do |notification|
      authorize! :read, notification
    end
  end
end
