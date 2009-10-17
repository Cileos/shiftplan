ActionView::Helpers::AssetTagHelper.module_eval do
  register_javascript_expansion :shiftplan => %w(
    lib/core_ext/array
    lib/core_ext/date
    lib/core_ext/uri
    lib/ejs
    lib/jquery/jquery
    lib/jquery/jquery-ui
    lib/jquery/jquery-plugin-form

    shiftplan/resource
    shiftplan/plan
    
    shiftplan/plan/shifts
    shiftplan/plan/shift
    shiftplan/plan/requirement
    shiftplan/plan/assignment
    shiftplan/plan/employee
    shiftplan/plan/workplace
    shiftplan/plan/qualification

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

