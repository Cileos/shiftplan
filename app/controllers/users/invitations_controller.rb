class Users::InvitationsController < Devise::InvitationsController

  respond_to :html, :js

  # Skipping the require_no_authentication filter prevents that an user who is logged
  # in already, but for some reason clicks on an 'Accept invitation' link to be
  # redirected.
  skip_before_filter :require_no_authentication
  before_filter :set_resource, :only => [:create, :edit]
  before_filter :check_if_employee_with_email_exists, :only => :create
  before_filter :check_if_confirmed_user, :only => [:edit]

  # POST /resource/invitation
  def create
    if resource
      # Do not create a new user but reinvite her if she has not accepted an invitation, yet.
      # Associate the employee with the invited user.
      resource.employee_id = params[resource_name][:employee_id]
      resource.invite!
    else
      # Create new user and invite her/him
      self.resource = resource_class.invite!(params[resource_name], current_inviter)
    end

    if resource.errors.empty?
      set_flash_message :notice, :send_instructions, :email => self.resource.email
      redirect_to employees_path
    else
      respond_with_navigational(resource) { render :new }
    end
  end

  # GET /resource/invitation/accept?invitation_token=abcdef
  def edit
    unless params[:invitation_token]
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

  def employee
    @employee ||= current_user.organization.employees.find_by_user_id(resource.id)
  end

  def employee_exists?
    employee && employee.id != params[:user][:employee_id].to_i
  end

  def after_invite_path_for(resource)
    employees_path
  end

  def set_resource
    self.resource = if params[:action] == 'edit'
      resource_class.to_adapter.find_first(:invitation_token => params[:invitation_token])
    elsif params[:action] == 'create'
      resource_class.find_by_email(params[resource_name][:email])
    end
  end

  # Make sure only one employee gets associated with a given email address/user.
  # The planner should not be able to assign the same email address to multiple employees
  # of his organization
  def check_if_employee_with_email_exists
    if resource && employee_exists?
      set_flash_message :error, :another_employee_already_exists_with_email,
        :email => self.resource.email, :employee_name => employee.name
      redirect_to employees_path
    end
  end

  # Make sure that a confirmed user is not asked to set a password again when she accepts an
  # invitation by clicking on an confirmation link.
  def check_if_confirmed_user
    if resource.confirmed? && resource.encrypted_password.present?
      resource.accept_invitation!
      set_flash_message :notice, :updated
      sign_in(resource_name, resource)
      redirect_to after_accept_path_for(resource)
    end
  end
end
