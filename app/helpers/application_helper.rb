module ApplicationHelper
  def abbr_tag(short, long, opts={})
    content_tag :abbr, short, opts.merge(:title => long)
  end
end
