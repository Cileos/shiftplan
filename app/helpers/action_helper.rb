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

  def entitify(icon)
    ('&#x' + icon + ';').html_safe
  end

  def i(name)
    entitify(Volksplaner.icons[:icons][name] || 'icon-missing')
  end

  # translate with textilize
  def tt(*a)
    textilize( translate(*a) ).html_safe
  end

  def tabs_for(*a, &block)
    Bootstrap::Tabs.for(self, *a, &block)
  end
end
