# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # def time_by_slot(hour, slot)
  #   [sprintf("%02d", hour), sprintf("%02d", slot * 15)].join(':')
  # end

  def day_names
    [].tap do |day_names|
      I18n.t(:'date.day_names').each_with_index { |d, i| day_names << [d, i] }
      day_names
    end
  end

  def resource_css_classes(plan)
    names = %w(resource)
    names << 'template' if plan.respond_to?(:template?) && plan.template?
    names << cycle('odd', 'even', :name => "#{plan.class.name.underscore}_cycle")
    names.join(' ')
  end
end
