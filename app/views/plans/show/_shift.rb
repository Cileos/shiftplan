class Plans::Show::Shift < Minimal::Template
  delegate :workplace, :requirements, :to => :shift

  def to_html
    li_for shift, attributes do
      h3 workplace.name
      ul :class => 'requirements' do
        render :partial => 'plans/show/requirement', :collection => requirements
      end
    end
  end

  def attributes
    {
      :class                           => dom_id(workplace),
      :'data-workplace-id'             => workplace.id,
      :'data-start'                    => shift.start_in_minutes,
      :'data-duration'                 => shift.duration,
      :'data-available_employee_ids'   => shift.plan.account.employees.map(&:id).to_json,
      # :'data-available_employee_ids'   => shift.statused_employee_ids('Available').to_json,
      # :'data-unavailable_employee_ids' => shift.statused_employee_ids('Unavailable').to_json,
      :'data-qualifications'           => shift.requirements.map(&:qualification).compact.map { |q| dom_id(q) }.uniq.to_json
    }
  end
end

