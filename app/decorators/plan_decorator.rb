class PlanDecorator < ApplicationDecorator
  decorates :plan

  def scheduling_form_template
    if employees_available?
      link_to_new_scheduling_form + employee_form
    end
  end

  private

  def link_to_new_scheduling_form
    h.link_to '.new_scheduling', "##{scheduling_form_id}", :class => 'new_scheduling', 'data-toggle' => 'modal', 'data-href' => "##{scheduling_form_id}"
  end


  # A form for a scheduling where neither the date nor the employee can be modified (hidden fields)
  def employee_form
    modal id: scheduling_form_id,
      body: h.render('schedulings/employee_form', :scheduling => plan.schedulings.new)
  end

  def plan
    model
  end

end

