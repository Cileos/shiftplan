class Users::InvitationsController < Devise::InvitationsController

  # Skipping the require_no_authentication filter prevents that an user who is logged
  # in already, but for some reason clicks on an 'Accept invitation' link to be
  # redirected.
  skip_before_filter :require_no_authentication

  protected

  def after_invite_path_for(resource)
    edit_employee_path(resource.employee_id)
  end
end
