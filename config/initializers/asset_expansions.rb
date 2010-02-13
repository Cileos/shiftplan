JQUERY_132 = %w(
  lib/jquery/jquery
  lib/jquery/jquery-ui
  lib/jquery/jquery-plugin-form
  lib/jquery/jquery-plugin-quicksearch
)
JQUERY_141 = %w(
  lib/jquery/jquery-1.4.1
  lib/jquery-ui-1.8rc1/jquery-ui
  lib/jquery-ui-1.8rc1/jquery-ui.js
  lib/jquery-ui-1.8rc1/jquery.ui.core.js
  lib/jquery-ui-1.8rc1/jquery.effects.core.js
  lib/jquery-ui-1.8rc1/jquery.effects.bounce.js
  lib/jquery-ui-1.8rc1/jquery.effects.highlight.js
  lib/jquery-ui-1.8rc1/jquery.ui.draggable.js
  lib/jquery-ui-1.8rc1/jquery.ui.droppable.js
  lib/jquery-ui-1.8rc1/jquery.ui.mouse.js
  lib/jquery-ui-1.8rc1/jquery.ui.position.js
  lib/jquery-ui-1.8rc1/jquery.ui.resizable.js
  lib/jquery-ui-1.8rc1/jquery.ui.sortable.js
  lib/jquery-ui-1.8rc1/jquery.ui.selectable.js
  lib/jquery-ui-1.8rc1/jquery.ui.datepicker.js
  lib/jquery-ui-1.8rc1/jquery.ui.dialog.js
  lib/jquery-ui-1.8rc1/jquery.ui.progressbar.js
  lib/jquery-ui-1.8rc1/jquery.ui.slider.js
  lib/jquery-ui-1.8rc1/jquery.ui.tabs.js
  lib/jquery-ui-1.8rc1/jquery.ui.widget.js
  lib/jquery-ui-1.8rc1/jquery.effects.blind.js
  lib/jquery-ui-1.8rc1/jquery.effects.clip.js
  lib/jquery-ui-1.8rc1/jquery.effects.drop.js
  lib/jquery-ui-1.8rc1/jquery.effects.explode.js
  lib/jquery-ui-1.8rc1/jquery.effects.fade.js
  lib/jquery-ui-1.8rc1/jquery.effects.fold.js
  lib/jquery-ui-1.8rc1/jquery.effects.pulsate.js
  lib/jquery-ui-1.8rc1/jquery.effects.scale.js
  lib/jquery-ui-1.8rc1/jquery.effects.shake.js
  lib/jquery-ui-1.8rc1/jquery.effects.slide.js
  lib/jquery-ui-1.8rc1/jquery.effects.transfer.js
  lib/jquery-ui-1.8rc1/jquery.ui.accordion.js
  lib/jquery-ui-1.8rc1/jquery.ui.autocomplete.js
  lib/jquery-ui-1.8rc1/jquery.ui.button.js
  lib/jquery/jquery-plugin-form
  lib/jquery/jquery-plugin-quicksearch
)

ActionView::Helpers::AssetTagHelper.module_eval do
  register_javascript_expansion :shiftplan => JQUERY_141 + %w(
    lib/core_ext/array
    lib/core_ext/date
    lib/core_ext/uri
    lib/ejs
    shiftplan/cursor
    shiftplan/resource
    shiftplan/plan

    shiftplan/plan/day
    shiftplan/plan/shifts
    shiftplan/plan/shift
    shiftplan/plan/requirement
    shiftplan/plan/assignment
    shiftplan/plan/employee
    shiftplan/plan/workplace
    shiftplan/plan/qualification
    shiftplan/plan/search

    shiftplan/stuff/dialogs
    shiftplan/stuff/lists
    shiftplan/stuff/workplaces

    application
  )

end

ActionView::Helpers::AssetTagHelper.module_eval do
  register_stylesheet_expansion :shiftplan => %w(
    reset
    layout
    header
    sidebar
    styles
    plan
    resources
    dashboard
    statuses
    search
  )
  # jquery-ui/ui-lightness/jquery-ui
end

