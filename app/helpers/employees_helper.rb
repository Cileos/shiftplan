module EmployeesHelper
  def invitation_status(employee)
    if employee.invitation_accepted?
      t(:'employees.invitation_status.invited_and_accepted',
        invitation_sent_at: l(employee.invitation_sent_at, format: :short),
        invitation_accepted_at: l(employee.invitation_accepted_at, format: :short))
    elsif employee.invited?
      t(:'employees.invitation_status.invited_not_accepted',
        invitation_sent_at: l(employee.invitation_sent_at, format: :short))
    else
      t(:'employees.invitation_status.not_invited')
    end
  end
end
