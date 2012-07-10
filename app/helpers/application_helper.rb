module ApplicationHelper
  def abbr_tag(short, long, opts={})
    content_tag :abbr, content_tag(:span, short), opts.merge(:title => long)
  end

  # HACK on every AJAX request, we deliver the mode of the plan in a header, so
  # the RJS responses can figure out the correct decorators
  def current_plan_mode
    request.headers['HTTP_X_SHIFTPLAN_MODE'].inquiry
  end
end
