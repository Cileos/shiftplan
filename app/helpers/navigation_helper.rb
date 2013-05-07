module NavigationHelper
  # renders a link (a) within a list item (li),
  # uses cancan to optionally hide it and
  # activates it if the current path matches
  #   a) the provided path or
  #   b) the given regex (TODO)
  #
  #     li_link '.dashboard', dashboard_path, can: [:dashboard, current_user]
  def li_link(name, path, options = {})
    can = options.delete(:can)
    if !can || can?(*can)
      path = polymorphic_path(path) unless path.is_a?(String)
      active = below_path?( path )
      content_tag :li, class: active && 'active' do
        link_to name, path, options
      end
    end
  end

  def dropdown_class(path)
    if below_path?(path)
      'active'
    else
      'not_active'
    end
  end

  def below_path?(path)
    path = polymorphic_path(path) unless path.is_a?(String)
    request.path.starts_with?( path )
  end

  def on_path?(path)
    path = polymorphic_path(path) unless path.is_a?(String)
    request.path == path
  end
end
