module ApplicationHelper
  def abbr_tag(short, long, opts={})
    content_tag :abbr, content_tag(:span, short), opts.merge(:title => long)
  end

  def masterhead_toolbar(&block)
    content_for :masterhead_toolbar, &block
  end
end
