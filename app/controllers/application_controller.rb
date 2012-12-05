class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!
  include Volksplaner::Currents
  before_filter :prefetch_current_employee, if: :user_signed_in? # to set it on current_user

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
  include EmberRailsFlash::FlashInHeader

  protected

  helper_method :nested_resources_for
  # returns an array to be used in link_to and other helpers containing the full-defined nesting for the given resource
  def nested_resources_for(resource)
    case resource
    when Comment
      nested_resources_for(resource.commentable.blog) + [ resource.commentable, resource]
    when Post
      nested_resources_for(resource.blog) + [resource]
    when Blog, Team, Plan, Qualification, PlanTemplate
      nested_resources_for(resource.organization) + [resource]
    when Organization
      [ resource.account, resource ]
    end
  end

  helper_method :year_for_cweek_at
  def year_for_cweek_at(date)
    if date.month == 1 && date.cweek > 5
      date.year - 1
    elsif date.month == 12 && date.cweek == 1
      date.year + 1
    else
      date.year
    end
  end

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
      if not current_user.is_multiple?
        if first = current_user.joined_organizations.first
          [first.account, first]
        else # has one account, but no membership
          dashboard_path
        end
      else
        dashboard_path
      end
    else
      root_path
    end
  end
end
