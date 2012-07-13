module HelpHelper
  def help_tag(key, options={})
    content_tag :div, class: "help" do
      textilize(translate(key, options.merge(:scope => 'help'))).html_safe
    end
  end
end
