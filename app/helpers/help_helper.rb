module HelpHelper
  def help_tag(key, options={})
    i18n = options.delete(:i18n) || {}
    content_tag :div, options.merge(class: "help") do
      textilize(translate(key, i18n.merge(:scope => 'help'))).html_safe
    end
  end
end
