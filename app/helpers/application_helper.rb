module ApplicationHelper
  def abbr_tag(short, long, opts={})
    content_tag :abbr, content_tag(:span, short), opts.merge(:title => long)
  end

  def masthead_toolbar(&block)
    content_for :masthead_toolbar, &block
  end
end
