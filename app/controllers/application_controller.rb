ActionView::Helpers::AssetTagHelper.module_eval do
  register_javascript_expansion :shiftplan => %w(
    core_ext/array
    core_ext/date
    core_ext/uri

    jquery/jquery
    jquery/jquery-ui

    shiftplan/plan/resource
    shiftplan/plan/plan
    shiftplan/plan/shifts
    shiftplan/plan/shift
    shiftplan/plan/requirement
    shiftplan/plan/assignment

    shiftplan/plan/employee
    shiftplan/plan/workplace
    shiftplan/plan/qualification

    shiftplan/plan/shiftplan
    shiftplan/plan/util
    shiftplan/plan/_init
    
    shiftplan/stuff/dialogs
    shiftplan/stuff/lists
    shiftplan/stuff/workplaces
  )
end

ActionView::Helpers::AssetTagHelper.module_eval do
  register_stylesheet_expansion :shiftplan => %w(
    reset
    shiftplan/plan

    calendar
    application
    jquery-ui/ui-lightness/jquery-ui
  )
end

class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  filter_parameter_logging :password, :password_confirmation

  before_filter :set_object_name

  protected

    def set_object_name
      @object_name ||= params[:controller].split('/').last.singularize
    end
end
