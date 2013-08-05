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
    WwtDiffWidget.new(self, employee, records).to_html
  end


  def update_wwt_diff_for(employee)
    select(:wwt_diff, employee).refresh_html wwt_diff_for(employee)
  end

end
