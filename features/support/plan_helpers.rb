module PlanHelpers
  def shift_days
    @shift_days ||= begin
      monday = Time.zone.parse('2009-09-07').to_date
      days = monday..(monday + 5.days)
      days = days.inject({}) { |days, date| days[date.strftime('%A')] = date; days }
    end
  end

  def reformat_date!(string)
    if string
      datetime = string.gsub(/(#{shift_days.keys.join('|')})/) { shift_days[$1] }
      datetime = Time.zone.parse(datetime)
      string.replace(datetime.to_s)
    end
  end

  def locate_body(&block)
    locate(:body, &block)
  end

  def locate_sidebar(&block)
    locate(:id => 'sidebar', &block)
  end

  def locate_plan(&block)
    locate(:class => 'plan', &block)
  end

  def locate_day(date, &block)
    reformat_date!(date)
    locate(:class => 'day', :'data-day' => date.to_date.to_s.gsub('-', ''), &block)
  end

  def locate_shifts(date, workplace = nil, &block)
    locate_day(date) do |element|
      if workplace
        workplace = Workplace.find_by_name(workplace)
        css_class = "workplace_#{workplace.id}"
      else
        css_class = "shifts"
      end
      locate(:ul, :class => css_class, &block)
    end
  end

  def locate_shift(date, workplace, &block)
    locate_day(date) do
      workplace = Workplace.find_by_name(workplace)
      locate(:ul, :class => "workplace workplace_#{workplace.id}") do
        locate(:li, :class => "shift", &block)
      end
    end
  end

  def locate_requirement(date, workplace, qualification, &block)
    locate_shift(date, workplace) do |shift|
      locate(:class => 'requirements') do |requirements|
        if qualification == 'any'
          locate(:class => "requirement", &block)
        else
          qualification = Qualification.find_by_name(qualification)
          locate(:class => "qualification_#{qualification.id}", &block)
        end
      end
    end
  end

  def locate_assignment(employee, date, workplace, qualification, &block)
    locate_requirement(date, workplace, qualification) do
      employee = Employee.find_by_name(employee)
      locate(:class => "employee_#{employee.id}", &block)
    end
  end

  def locate_employee(name, &block)
    employee = Employee.find_by_name(name)
    locate_sidebar do
      locate(:class => "employee_#{employee.id}", &block)
    end
  end

  def locate_workplace(name, &block)
    workplace = Workplace.find_by_name(name)
    locate_sidebar { locate(:href => "/workplaces/#{workplace.id}", &block) }
  end

  def locate_qualification(name, &block)
    qualification = Qualification.find_by_name(name)
    locate_sidebar { locate(:href => "/qualifications/#{qualification.id}", &block) }
  end

  def find_shift(date, workplace)
    find_shifts(date, workplace).first
  end

  def find_shifts(date, workplace)
    reformat_date!(date)
    workplace = Workplace.find_by_name(workplace)
    workplace.shifts.all(:conditions => ['DATE(start) = ?', date])
  end

  def find_requirement(date, workplace, qualification)
    find_requirements(date, workplace, qualification).first
  end

  def find_requirements(date, workplace, qualification)
    shift = find_shift(date, workplace)
    qualification = Qualification.find_by_name(qualification)
    shift.requirements.all(:conditions => ['qualification_id = ?', qualification.id])
  end

  def find_assignment(employee, date, workplace, qualification)
    employee = Employee.find_by_name(employee)
    requirement = find_requirement(date, workplace, qualification)
    requirement.assignment
  end
end

World(PlanHelpers)
