class IcalendarTemplateHandler
  def call(template)
    return <<-EORUBY
      cal = Icalendar::Calendar.new
      #{template.source}
      cal.to_ical
    EORUBY
  end
end

ActionView::Template.register_template_handler(:icalendar, IcalendarTemplateHandler.new)
