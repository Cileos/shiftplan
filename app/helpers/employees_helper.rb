module EmployeesHelper
  def invitation_status(employee)
    if employee.invitation_accepted? || employee.planner? || employee.owner?
      t(:'employees.invitation_status.active')
    elsif employee.invited?
      (invitation_link(:reinvite, employee) + ' ' +
        t(:'employees.invitation_status.invited', invited_at: l(employee.invitation_sent_at, format: :tiny))
      ).html_safe
    else
      invitation_link(:invite, employee)
    end
  end

  def invitation_link(text, employee)
    link_to ti(text.to_sym, :'non-white' => true), new_user_invitation_path( user: { employee_id: employee.id } ),
      class: 'btn btn-mini pull-right', :remote => true
  end
end
