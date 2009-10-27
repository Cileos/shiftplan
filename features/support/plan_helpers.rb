module PlanHelpers
  def shift_days
    @shift_days ||= begin
      monday = Date.parse('2009-09-07')
      days = monday..(monday + 5.days)
      days = days.inject({}) { |days, date| days[date.strftime('%A')] = date; days }
    end
  end

  def reformat_date!(string)
    string.gsub!(/(#{shift_days.keys.join('|')})/) { shift_days[$1] } if string
  end

  def locate_sidebar(&block)
    locate_element(:id => 'sidebar', &block)
  end

  def locate_body(&block)
    locate_element(:body, &block)
  end

  def locate_plan(&block)
    locate_element(:class => 'plan', &block)
  end

  def locate_day(date, &block)
    reformat_date!(date)
    locate_element(:class => 'day', :'data-day' => date.gsub('-', ''), &block)
  end

  def locate_shifts(date, &block)
    locate_day(date) do
      locate_element(:ul, &block)
    end
  end

  def locate_shift(date, workplace, &block)
    locate_day(date) do
      workplace = Workplace.find_by_name(workplace)
      locate_element(:class => 'shift', :class => "workplace_#{workplace.id}", &block)
    end
  end

  def locate_requirement(date, workplace, qualification, &block)
    locate_shift(date, workplace) do |shift|
      locate_element(:class => 'requirements') do |requirements|
        if qualification == 'any'
          locate_element(:class => "requirement", &block)
        else
          qualification = Qualification.find_by_name(qualification)
          locate_element(:class => "qualification_#{qualification.id}", &block)
        end
      end
    end
  end

  def locate_assignment(employee, date, workplace, qualification, &block)
    locate_requirement(date, workplace, qualification) do
      employee = Employee.find_by_name(employee)
      locate_element(:class => "employee_#{employee.id}", &block)
    end
  end

  def locate_employee(name)
    employee = Employee.find_by_name(name)
    # FIXME should be able to use select_element("#sidebar .employee_1 div")
    locate_sidebar do
      locate_element(:class => "employee_#{employee.id}") do
        locate_element(:div)
      end
    end
  end

  def locate_workplace(name)
    workplace = Workplace.find_by_name(name)
    locate_sidebar { locate_element(:href => "/workplaces/#{workplace.id}") }
  end

  def locate_qualification(name)
    qualification = Qualification.find_by_name(name)
    locate_sidebar { locate_element(:href => "/qualifications/#{qualification.id}") }
  end

  def find_shift(date, workplace)
    reformat_date!(date)
    workplace = Workplace.find_by_name(workplace)
    workplace.shifts.find(:first, :conditions => ['DATE(start) = ?', date])
  end

  def find_requirement(date, workplace, qualification)
    shift = find_shift(date, workplace)
    qualification = Qualification.find_by_name(qualification)
    shift.requirements.find(:first, :conditions => ['qualification_id = ?', qualification.id])
  end

  def find_assignment(employee, date, workplace, qualification)
    employee = Employee.find_by_name(employee)
    requirement = find_requirement(date, workplace, qualification)
    requirement.assignment
  end
end

World(PlanHelpers)
