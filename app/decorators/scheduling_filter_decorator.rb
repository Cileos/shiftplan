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
    schedulings = schedulings_for(day, employee)
    unless schedulings.empty?
      h.render "schedulings/list_in_#{range || 'unknown'}",
        schedulings: schedulings
    end
  end

  def schedulings_for(day, employee)
    filter.indexed(day, employee)
  end

  def cell_metadata(day, employee)
    { employee_id: employee.id, date: day.iso8601 }
  end

  def cell_selector(day, employee)
    %Q~#calendar tbody td[data-date=#{day.iso8601}][data-employee_id=#{employee.id}]~
  end


  def hours_header
    if week?
      h.content_tag :th, h.translate_action(:hours)
    end
  end

  # Planned in hours for given employee
  def hours_tag_for(employee)
    if week?
      h.content_tag :td, hours_for(employee),
        :class => 'hours',
        'data-employee_id' => employee.id
    end
  end

  def hours_selector_for(employee)
    %Q~#calendar tbody td.hours[data-employee_id=#{employee.id}]~
  end

  def hours_for(employee)
    records.select {|s| s.employee == employee }.sum(&:length_in_hours).to_i
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

  def link_to_previous_week
    week = first_day.prev_week
    h.link_to :previous_week, h.plan_year_week_path(plan, week.year, week.cweek)
  end

  def link_to_next_week
    week = first_day.next_week
    h.link_to :next_week, h.plan_year_week_path(plan, week.year, week.cweek)
  end


end
