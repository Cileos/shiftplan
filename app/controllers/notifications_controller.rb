class NotificationsController < InheritedResources::Base
  actions :index, :update
  custom_actions resource: :read

  defaults resource_class: Notification::Base,
    collection_name: 'notifications',
    instance_name: 'notification'

  load_and_authorize_resource class: Notification::Base

  respond_to :js, :html


  def read
    resource.read_at = Time.zone.now
    resource.save!
  end

  protected

  def begin_of_association_chain
    current_user
  end

  def end_of_association_chain
    super.unread.default_sorting
  end
end
