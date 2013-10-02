class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!
  include Volksplaner::Currents

  rescue_from CanCan::AccessDenied do |exception|
    logger.debug('Access denied')
    flash.now[:alert] = translate('message.access_denied')
    respond_to do |denied|
      denied.html { redirect_to user_signed_in?? dashboard_url : root_url }
      denied.js   { render 'denied' }
    end
  end
  layout 'application'

  check_authorization :unless => :devise_controller?

  include UrlHelper
  include EmberRailsFlash::FlashInHeader

  unless Rails.env.production?
    before_filter do
      Volksplaner::IconCompiler.observe Rails.root/'config/icons.yml', Rails.root/'app/assets/stylesheets/compiled/_icons.css.scss'
      true
    end
  end

  protected

  prepend_before_filter :set_locale
  def set_locale
    if user_signed_in?
      if current_user.locale.present?
        I18n.locale = current_user.locale.to_sym
      else
        save_browser_or_english_locale_for_user
      end
    else
       set_browser_or_english_locale
    end
    true
  end

  # TODO detect secondary (..) accepted language
  def browser_locale
    @browser_locale ||= if header = request.env['HTTP_ACCEPT_LANGUAGE']
      header.scan(/^[a-z]{2}/).first
    end
  end

  def browser_locale_supported?
    I18n.available_locales.map(&:to_s).include?(browser_locale)
  end

  def save_browser_or_english_locale_for_user
    if browser_locale && browser_locale_supported?
      current_user.update_attributes!(locale: browser_locale.to_s)
    else
      current_user.update_attributes!(locale: 'en')
    end
  end

  def set_browser_or_english_locale
    if browser_locale && browser_locale_supported?
      I18n.locale = browser_locale.to_sym
    else
      I18n.locale = :en
    end
  end

  helper_method :nested_resources_for
  # returns an array to be used in link_to and other helpers containing the full-defined nesting for the given resource
  def nested_resources_for(resource, *extra)
    case resource
    when Comment
      nested_resources_for(resource.commentable.blog) + [ resource.commentable, resource]
    when Post
      nested_resources_for(resource.blog) + [resource]
    when Blog, Team, Plan, PlanTemplate
      nested_resources_for(resource.organization) + [resource]
    when Organization
      [ resource.account, resource ]
    when Shift
      nested_resources_for(resource.plan_template) + [resource]
    when Scheduling, AttachedDocument
      nested_resources_for(resource.plan) + [resource]
    end + extra
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
      if not current_user.multiple?
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

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
