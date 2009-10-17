ActionView::Helpers::AssetTagHelper.module_eval do
  register_javascript_expansion :shiftplan => %w(
    core_ext/array
    core_ext/date
    core_ext/uri

    jquery/jquery
    jquery/jquery-ui
    jquery/jquery-plugin-form

    shiftplan/resource
    shiftplan/plan
    
    shiftplan/plan/shifts
    shiftplan/plan/shift
    shiftplan/plan/requirement
    shiftplan/plan/assignment
    shiftplan/plan/employee
    shiftplan/plan/workplace
    shiftplan/plan/qualification

    shiftplan/plan/_init

    shiftplan/employees/employee

    shiftplan/stuff/dialogs
    shiftplan/stuff/lists
    shiftplan/stuff/workplaces

    application
  )
end

ActionView::Helpers::AssetTagHelper.module_eval do
  register_stylesheet_expansion :shiftplan => %w(
    reset
    shiftplan/plan

    application
  )
  # jquery-ui/ui-lightness/jquery-ui
end

