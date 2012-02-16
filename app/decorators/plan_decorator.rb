class PlanDecorator < ApplicationDecorator
  decorates :plan

  def quickies_for(employee, day)
    schedulings_for(employee, day).map { |s| quickie_for s }
  end

  def quickie_list(employee, day)
    h.render :partial => 'plans/quickie_list', :locals => { :quickie_list =>  quickies_for(employee, day) }
  end

  def schedulings
    @schedulings ||= model.schedulings
  end

  def quickie_for(s)
    "#{s.starts_at.hour}-#{s.ends_at.hour}"
  end

  def employees
    model.organization.employees.order_by_name
  end

  def cell_selector(employee, day)
    %Q~#calendar tbody td[data-day=#{day}][data-employee_id=#{employee.id}]~
  end

  def hours_selector_for_employee(employee)
    %Q~#calendar tbody td.hours[data-employee_id=#{employee.id}]~
  end

  def respond_to_missing?(name)
    name =~ /^(.*)_for_scheduling$/ || super
  end

  # you can call a method anding in _for_scheduling
  def method_missing(name, *args, &block)
    if name =~ /^(.*)_for_scheduling$/
      scheduling = args.first
      send($1, scheduling.employee, scheduling.week_day)
    else
      super
    end
  end

  def dom_id
    h.dom_id(model)
  end

  def new_scheduling_dom_id
    h.dom_id(model, 'new_scheduling')
  end

  # Planned in hours for given employee
  def hours_for(employee)
    schedulings.for_employee(employee).sum(&:length_in_hours).to_i
  end

  private

  def schedulings_for(employee, day)
    schedulings.for_employee(employee).for_day(day)
  end

  # Accessing Helpers
  #   You can access any helper via a proxy
  #
  #   Normal Usage: helpers.number_to_currency(2)
  #   Abbreviated : h.number_to_currency(2)
  #
  #   Or, optionally enable "lazy helpers" by calling this method:
  #     lazy_helpers
  #   Then use the helpers with no proxy:
  #     number_to_currency(2)

  # Defining an Interface
  #   Control access to the wrapped subject's methods using one of the following:
  #
  #   To allow only the listed methods (whitelist):
  #     allows :method1, :method2
  #
  #   To allow everything except the listed methods (blacklist):
  #     denies :method1, :method2

  # Presentation Methods
  #   Define your own instance methods, even overriding accessors
  #   generated by ActiveRecord:
  #
  #   def created_at
  #     h.content_tag :span, time.strftime("%a %m/%d/%y"),
  #                   :class => 'timestamp'
  #   end
end


class Array
  # give a real employee
  def for_employee(employee)
    select {|i| i.employee_id == employee.id }
  end

  # give a day number (?)
  def for_day(day)
    select {|i| i.week_day == day }
  end
end
