class Plans::Sidebar::Employee < Minimal::Template
  def to_html
    li do
      link_to(employee.initials, employee_path(employee), attributes)
    end
  end

  def attributes
    {
      :class => "#{employee.class.name.underscore} #{dom_id(employee)} #{qualifications.join(' ')}",
      :title => employee.full_name,
      :'data-qualifications' => qualifications.to_json
    }
  end

  def qualifications
    employee.qualifications.map { |qualification| dom_id(qualification) }
  end

  def qualified_workplaces
    employee.qualified_workplaces.map { |workplace| dom_id(workplace) }
  end

  def available_shifts
    plan.shifts.select do |shift|

    end
  end

  def unavailable_shifts
    []
  end

  def available_on
    @available_on ||= employee.statuses.for(plan.start_date, plan.end_date, :status => 'Available')
  end

  def unavailable_on
    @unavailable_on ||= employee.statuses.for(plan.start_date, plan.end_date, :status => 'Unavailable')
  end
end
