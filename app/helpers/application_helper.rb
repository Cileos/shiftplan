module ApplicationHelper
  def translate_action(key,opts={})
    if key.is_a?(Symbol)
      t("helpers.actions.#{key}", opts)
    elsif key.present? && key.first == '.'
      t("helpers.actions#{key}", opts)
    else
      key
    end
  end

  alias ta translate_action

  def link_to(text, *args, &block)
    super translate_action(text), *args, &block
  end

  def translate_icon(key, opts={})
    content_tag(:i, '', class: "icon-#{Icons[key] || 'glass'} #{'icon-white' unless opts[:'non-white']}") + ' ' + translate_action(key, opts)
  end
  alias ti translate_icon

  Icons = {
    add: 'plus',
    new_scheduling: 'plus',
    copy_week: 'retweet',
    update: 'ok-circle',
    invite: 'user',
    reinvite: 'user',
    send_invitation: 'envelope'
  }

  # translate with textilize
  def tt(*a)
    textilize( translate(*a) ).html_safe
  end
end
