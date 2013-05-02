module ActionHelper
  def translate_action(*a)
    translate_action!(*a)
  rescue I18n::MissingTranslationData => e
    return a.first
  end
  def translate_action!(key,opts={})
    if opts[:translation_key].present?
      I18n.translate!(opts.delete(:translation_key), opts)
    elsif key.is_a?(Symbol)
      I18n.translate!("helpers.actions.#{key}", opts)
    elsif key.present? && key.respond_to?(:first) && key.first == '.'
      I18n.translate!("helpers.actions#{key}", opts)
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

  Icons = {
    add:               '&#xf067;',
    edit:              'edit',
    destroy:           '&#xf00d;',
    new_plan:          'plus',
    new_scheduling:    'plus',
    new_organization:  'plus',
    copy_week:         '&#xf079',
    update:            'ok-circle',
    invite:            'user',
    reinvite:          'user',
    comment:           '&#xf075;',
    no_comment:        '&#xf0e5;',
    comments_count:    'comment',
    reply:             '&#xf053;',
    back:              'arrow-left',
    send_invitation:   'envelope',
    feedback_without_screenshot: 'envelope',
    send:                        'envelope',
    dropdown:          '&#xf073;',
    dashboard:         '&#xf0e4;',
    organization:      '&#xf015;',
    news:              '&#xf0e7;',
    employees:         '&#xf007;',
    teams:             '&#xf0e8;',
    settings:          '&#xf007;',
    signup:            '&#xf007;',
    signout:           '&#xf08b;',
    signin:            '&#xf090;',
    edit_post:         '&#xf044;',
    expand:            '&#xf0da;',
    collapse:          '&#xf0d7;',
    left_caret:        '&#xf0d9;',
    check:             '&#xf00c;',
    notice:            '&#xf00c;',
    info:              '&#xf00c;',
    warning:           '&#xf071;',
    error:             '&#xf071;',
    alert:             '&#xf00d;'

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
end
