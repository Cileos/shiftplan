class PlanDecorator < ApplicationDecorator
  decorates :plan


  def new_scheduling
    if employees_available?
      link_to_new_scheduling_form + new_scheduling_form
    end
  end

  private

  def link_to_new_scheduling_form
    h.link_to '.new_scheduling', "##{new_scheduling_dom_id}", :class => 'new_scheduling', 'data-toggle' => 'modal'
  end

  def new_scheduling_form
    modal new_scheduling_dom_id do
      h.render 'schedulings/new_form', :scheduling => plan.schedulings.new
    end
  end

  def plan
    model
  end

end

