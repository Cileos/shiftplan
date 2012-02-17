class SchedulingFilterDecorator < ApplicationDecorator
  decorates :scheduling_filter

  # The title of the plan with range
  def caption
    "#{plan.name} - #{formatted_range}"
  end

  def formatted_range
    case range
    when :week
      I18n.localize filter.first_day, format: :week_with_first_day
    else
      '???'
    end
  end

  def formatted_days
    days.map { |day| I18n.localize(day, format: :week_day) }
  end

  def filter
    model
  end

  def cell_content(day, employee)
    h.render "schedulings/list_in_#{range || 'unknown'}",
      schedulings: schedulings_for(day, employee)
  end

  def schedulings_for(day, employee)
    filter.indexed(day, employee)
  end

  def cell_metadata(day, employee)
    { employee_id: employee.id, day: day.cwday }
  end

  def cell_selector(day, employee)
    %Q~#calendar tbody td[data-day=#{day}][data-employee_id=#{employee.id}]~
  end


  def hours_header
    if week?
      h.content_tag :th, h.translate_action(:hours)
    end
  end

  # Planned in hours for given employee
  def hours_for(employee)
    if week?
      hours = records.select {|s| s.employee == employee }.sum(&:length_in_hours).to_i
      h.content_tag :td, hours,
        :class => 'hours',
        :data  => { employee_id: employee.id }
    end
  end

  def hours_selector_for(employee)
    %Q~#calendar tbody td.hours[data-employee_id=#{employee.id}]~
  end


  def employees
    organization.employees.order_by_name
  end

  delegate :plan,         to: :filter
  delegate :organization, to: :plan

  def respond_to_missing?(name)
    name =~ /^(.*)_for_scheduling$/ || super
  end

  # you can call a method anding in _for_scheduling
  def method_missing(name, *args, &block)
    if name =~ /^(.*)_for_scheduling$/
      scheduling = args.first
      send($1, scheduling.date, scheduling.employee)
    else
      super
    end
  end


end
