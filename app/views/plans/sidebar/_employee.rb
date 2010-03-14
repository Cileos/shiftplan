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
      :'data-possible-workplaces' => possible_workplaces,
      :title => employee.full_name
    }
  end

  def qualifications
    employee.qualifications.map { |qualification| dom_id(qualification) }.join(', ')
  end

  def possible_workplaces
    employee.possible_workplaces.map { |workplace| dom_id(workplace) }.join(', ')
  end
end
