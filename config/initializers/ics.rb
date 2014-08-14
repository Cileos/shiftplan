class IcsTemplateHandler
  def call(template)
    return <<-EORUBY
      RiCal.Calendar do |cal|
      #{template.source}
      end
    EORUBY
  end
end

ActionView::Template.register_template_handler(:ics, IcsTemplateHandler.new)
