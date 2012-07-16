class ApplicationController < ActionController::Base
  protect_from_forgery

  authentication_required
  before_filter :set_current_employee, if: :user_signed_in?

  rescue_from CanCan::AccessDenied do |exception|
    logger.debug('Access denied')
    flash[:alert] = translate('message.access_denied')
    respond_to do |denied|
      denied.html { redirect_to root_url }
      denied.js   { render 'denied' }
    end
  end

  check_authorization :unless => :devise_controller?

  protected

  def set_flash(severity, key=nil, opts={})
    key ||= severity
    action = opts.delete(:action) || params[:action]
    controller = opts.delete(:controller) || params[:controller]
    flash[severity] = t("flash.#{controller}.#{action}.#{key}", opts)
  end

  def organization_param; params[:organization_id] end

  def set_current_employee
    if organization_param
      current_user.current_employee = current_user.employees.find_by_organization_id!(organization_param)
    end
  end

  def current_organization
    @current_organization ||= organization_param && current_user.organizations.find(organization_param)
  end
  helper_method :current_organization

  def current_employee
    current_user.try :current_employee
  end
  helper_method :current_employee

  def current_organization?
    current_organization.present?
  end
  helper_method :current_organization?

  # HACK on every AJAX request, we deliver the mode of the plan in a header, so
  # the RJS responses can figure out the correct decorators
  def current_plan_mode
    if mode = request.headers['HTTP_X_SHIFTPLAN_MODE'] || params['_shiftplan_mode']
      mode.inquiry
    else
      nil
    end
  end
  helper_method :current_plan_mode
end
