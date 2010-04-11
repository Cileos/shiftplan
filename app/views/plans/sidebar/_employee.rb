class Plans::Sidebar::Employee < Minimal::Template
  def content
    li do
      link_to(employee.initials, employee_path(employee), attributes)
    end
  end

  def attributes
    {
      :class => "#{employee.class.name.underscore} #{dom_id(employee)} dialog",
      :'data-qualifications' => qualifications,
      :'data-qualified-workplaces' => qualified_workplaces,
      # :'data-available-on' => available_on,
      # :'data-unavailable-on' => unavailable_on,
      :title => employee.full_name
    }
  end

  def qualifications
    employee.qualifications.map { |qualification| dom_id(qualification) }.join(', ')
  end

  def qualified_workplaces
    employee.qualified_workplaces.map { |workplace| dom_id(workplace) }.join(', ')
  end

  def available_on
    statuses = self.statuses.values.flatten.uniq
    return
    statuses.inject({}) do |result, (date, statuses)| 
      result[date] = statuses.select { |status| status.status == 'Available' }
      result
    end.to_json
  end

  # def unavailable_on
  #   self.statuses.inject({}) do |result, (date, statuses)| 
  #     result[date] = statuses.select { |status| status.status == 'Unavailable' }
  #     result
  #   end.to_json
  # end

  def statuses
    @statuses ||= employee.statuses.for(plan.start_date, plan.end_date)
  end
end
