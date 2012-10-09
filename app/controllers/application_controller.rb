class ApplicationController < ActionController::Base
  protect_from_forgery

  authentication_required
  include Volksplaner::Currents
  before_filter :set_current_account, if: :user_signed_in?
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

  include UrlHelper

  protected

  def set_flash(severity, key=nil, opts={})
    key ||= severity
    action = opts.delete(:action) || params[:action]
    controller = opts.delete(:controller) || params[:controller]
    flash[severity] = t("flash.#{controller}.#{action}.#{key}", opts)
  end



  # TODO test
  def dynamic_dashboard_path
    # Maybe make dynamic again later.  E.g., if a user just has one account, we
    # might want to show him a "only one account" optimized dashboard.
    if user_signed_in?
      if current_user.joined_organizations.count == 1
        first = current_user.joined_organizations.first
        [first.account, first]
      else
        dashboard_path
      end
    else
      root_path
    end
  end
end
