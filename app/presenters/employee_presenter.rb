class EmployeePresenter < Presenter
  def attributes
    { 
      :class => "#{employee.class.name.underscore} #{dom_id(employee)} dialog",
      :'data-qualifications' => qualifications.join(', '),
      :'data-possible-workplaces' => possible_workplaces.join(', ')
    }
  end
  
  def qualifications
    employee.qualifications.map { |qualification| dom_id(qualification) }
  end

  def possible_workplaces
    employee.possible_workplaces.map { |workplace| dom_id(workplace) }
  end
  
  def render
    li do
      link_to(initials, employee_path(employee), attributes)
    end
  end
end


