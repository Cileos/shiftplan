class ProfileController < InheritedResources::Base
  defaults resource_class: User, instance_name: 'user'

  skip_authorization_check
  before_filter :authorize_update_self

  def update
    update! { edit_profile_path }
  end

  protected

  def resource
    current_user
  end

  # flash messages should be in the new locale
  def update_resource(*)
    super.tap { set_locale }
  end

  def authorize_update_self
    authorize! :update_self, resource
  end
end
