class SchedulingFilterEmployeesInWeekDecorator < SchedulingFilterWeekDecorator
  def selector_for(name, resource=nil, extra=nil)
    case name
    when :wwt_diff
      %Q~#calendar tbody tr[data-employee-id=#{resource.id}] th .wwt_diff~
    else
      super
    end
  end
  def cell_metadata(day, employee)
    { :'employee-id' => employee.try(:id) || 'missing', :date => day.iso8601 }
  end


  def y_attribute
    :employee
  end

  def update_cell_for(scheduling)
    update_wwt_diff_for(scheduling.employee) if scheduling.employee.present?
    super
  end

  def wwt_diff_for(employee)
    h.abbr_tag(wwt_diff_label_text_for(employee, short: true),
               wwt_diff_label_text_for(employee),
               class: "badge #{wwt_diff_label_class_for(employee)}")
  end

  def wwt_diff_label_text_for(employee, opts={})
    if employee.weekly_working_time.present?
      opts[:short].present? ? txt = '/' : txt = 'of'
      "#{hours_for(employee)} #{txt} #{employee.weekly_working_time.to_i}"
    else
      "#{hours_for(employee)}"
    end
  end

  # the 'badge-normal' class is not actually used by bootstrap, but we cannot test for absent class
  def wwt_diff_label_class_for(employee)
    return 'badge-normal' unless employee.weekly_working_time.present?
    difference = employee.weekly_working_time - hours_for(employee)
    if difference > 0
      'badge-warning'
    elsif difference < 0
      'badge-important'
    else
      'badge-success'
    end
  end

  def update_wwt_diff_for(employee)
    select(:wwt_diff, employee).refresh_html wwt_diff_for(employee)
  end

end
