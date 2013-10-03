class NotificationsController < InheritedResources::Base
  actions :index

  defaults resource_class: Notification::Base,
    collection_name: 'notifications',
    instance_name: 'notification'

  load_and_authorize_resource class: Notification::Base

  respond_to :js, :html

  protected

  def begin_of_association_chain
    current_user
  end

  def end_of_association_chain
    super.for_hub
  end
end
