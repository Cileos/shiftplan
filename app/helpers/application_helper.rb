module ApplicationHelper
  def abbr_tag(short, long, opts={})
    content_tag :abbr, content_tag(:span, short), opts.merge(:title => long)
  end

  def collapsible(heading, opts={}, &block)
    content_tag(:div, opts.merge(data:{'toggle' => 'collapsible'})) do
      content_tag(:div, heading, data:{'toggle' => 'collapsible-heading'}) +
      content_tag(:div, data:{'toggle' => 'collapsible-content'}) do
        capture(&block)
      end
    end
  end

  def masterhead_toolbar(&block)
    content_for :masterhead_toolbar, &block
  end

  def static_landing_page_url
    'http://clockwork.io'
  end

  def yes_or_no_tag( bool )
    yes_or_no = bool ? 'yes' : 'no'
    human     = t("dialogue.#{yes_or_no}")
    content_tag :span, human, :class => "bool #{yes_or_no}"
  end

end
