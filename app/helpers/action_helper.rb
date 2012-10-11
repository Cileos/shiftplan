module ActionHelper
  def translate_action(key,opts={})
    if opts[:translation_key].present?
      t(opts.delete(:translation_key), opts)
    elsif key.is_a?(Symbol)
      t("helpers.actions.#{key}", opts)
    elsif key.present? && key.respond_to?(:first) && key.first == '.'
      t("helpers.actions#{key}", opts)
    else
      key
    end
  end

  alias ta translate_action

  def link_to(text, *args, &block)
    super translate_action(text), *args, &block
  end

  def button_to(text, *args, &block)
    super translate_action(text), *args, &block
  end

  def translate_icon(key, opts={})
     icon(key, opts) + translate_action(key, opts)
  end
  alias ti translate_icon

  def icon(key, opts={})
    content_tag(:i, '', class: "icon-#{Icons[key] || 'glass'} #{'icon-white' unless opts[:'non-white']}") + ' '
  end

  Icons = {
    add:               '&#xf067;',
    edit:              'edit',
    destroy:           '&#xf00d;',
    new_scheduling:    'plus',
    new_organization:  'plus',
    copy_week:         'retweet',
    update:            'ok-circle',
    invite:            'user',
    reinvite:          'user',
    comment:           '&#xf075;',
    comments_count:    'comment',
    reply:             '&#xf053;',
    back:              'arrow-left',
    send_invitation:   'envelope',
    feedback_without_screenshot: 'envelope',
    send:                        'envelope',
    news:              '&#xf015;',
    dropdown:          '&#xf073;',
    employees:         '&#xf007;',
    tems:              '&#xf0e8;',
    settings:          '&#xf007;',
    signup:            '&#xf007;',
    signout:           '&#xf08b;',
    signin:            '&#xf090;',
    edit_post:         '&#xf044;',

  }

  def i(name)
    (Icons[name] || 'icon-missing').html_safe
  end

  # translate with textilize
  def tt(*a)
    textilize( translate(*a) ).html_safe
  end

  def tabs_for(*a, &block)
    Bootstrap::Tabs.for(self, *a, &block)
  end

  # returns an array to be used in link_to and other helpers containing the full-defined nesting for the given resource
  def nested_resources_for(resource)
    case resource
    when Comment
      nested_resources_for(resource.commentable.blog) + [ resource.commentable, resource]
    when Post
      nested_resources_for(resource.blog) + [resource]
    when Blog, Team
      nested_resources_for(resource.organization) + [resource]
    when Organization
      [ resource.account, resource ]
    end
  end
end
