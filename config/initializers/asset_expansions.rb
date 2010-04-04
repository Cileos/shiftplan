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
    activities
  )
end
