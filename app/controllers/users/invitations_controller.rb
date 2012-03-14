class Users::InvitationsController < Devise::InvitationsController

  respond_to :html, :js

  # Skipping the require_no_authentication filter prevents that an user who is logged
  # in already, but for some reason clicks on an 'Accept invitation' link to be
  # redirected.
  skip_before_filter :require_no_authentication

  # POST /resource/invitation
  def create
    self.resource = resource_class.find_by_email(params[resource_name][:email])
    if resource
      if !resource.invitation_accepted_at?
        resource.employee_id = params[resource_name][:employee_id]
        resource.invite!
      end
    else
      self.resource = resource_class.invite!(params[resource_name], current_inviter)
    end

    if resource.errors.empty?
      set_flash_message :notice, :send_instructions, :email => self.resource.email
      respond_with resource, :location => after_invite_path_for(resource)
    else
      respond_with_navigational(resource) { render :new }
    end
  end

  # GET /resource/invitation/accept?invitation_token=abcdef
  def edit
    if params[:invitation_token] &&
      self.resource = resource_class.to_adapter.find_first( :invitation_token => params[:invitation_token] )
      # Do not ask the user to set a password again when she has already confirmed her account
      if resource.confirmed? && resource.encrypted_password.present?
        resource.accept_invitation!
        set_flash_message :notice, :updated
        sign_in(resource_name, resource)
        redirect_to after_accept_path_for(resource)
      else
        render :edit
      end
    else
      set_flash_message(:alert, :invitation_token_invalid)
      redirect_to after_sign_out_path_for(resource_name)
    end
  end

  # PUT /resource/invitation
  def update
    self.resource = resource_class.accept_invitation!(params[resource_name])
    if resource.errors.empty?
      resource.confirm! unless resource.confirmed?
      set_flash_message :notice, :updated
      sign_in(resource_name, resource)
      respond_with resource, :location => after_accept_path_for(resource)
    else
      respond_with_navigational(resource){ render :edit }
    end
  end


  protected

  def after_invite_path_for(resource)
    employees_path
  end
end
