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
    h.render "schedulings/list_in_#{range}",
      schedulings: schedulings_for(day, employee)
  end

  def schedulings_for(day, employee)
    filter.indexed(day, employee)
  end

  def cell_metadata(day, employee)
    { employee_id: employee.id, day: day.cwday }
  end

  def hours_header
    if week?
      h.content_tag :th, h.translate_action(:hours)
    end
  end

  # Planned in hours for given employee
  def hours_for(employee)
    if week?
      h.content_tag :td,
        records.select {|s| s.employee == employee }
               .sum(&:length_in_hours).to_i,
        class: 'hours',
        data: { employee_id: employee.id }
    end
  end

  delegate :plan,         to: :filter
  delegate :organization, to: :plan
  delegate :employees,    to: :organization

 #           - week_day = column.to_date.cwday
 #           %td{data: {employee_id: employee.id, day: week_day}}= plan.quickie_list(employee, week_day)
 #         %td.hours{data: {employee_id: employee.id}}= plan.hours_for(employee)



end
