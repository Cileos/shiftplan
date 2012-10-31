module ApplicationHelper
  def abbr_tag(short, long, opts={})
    content_tag :abbr, content_tag(:span, short), opts.merge(:title => long)
  end

  def collapsible(heading, opts={}, &block)
    content_tag(:div, opts.merge(data:{'toggle' => 'collapsible'})) do
      content_tag(:div, heading, data:{'toggle' => 'collapsible-heading', 'icon' => icon="&#xf0d7;".html_safe}) +
      content_tag(:div, data:{'toggle' => 'collapsible-content'}) do
        capture(&block)
      end
    end
  end

  def masterhead_toolbar(&block)
    content_for :masterhead_toolbar, &block
  end
end
