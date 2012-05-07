module EmployeesHelper
  def invitation_status(employee)
    if employee.active?
      t(:'employees.invitation_status.active')
    elsif employee.invited?
      if can? :manage, employee.invitation
        (invitation_link(:reinvite, employee) + ' ' +
          t(:'employees.invitation_status.invited', invited_at: l(employee.invitation.sent_at, format: :tiny))
        ).html_safe
      else
        t(:'employees.invitation_status.invited', invited_at: l(employee.invitation.sent_at, format: :tiny))
      end
    else
      can?(:manage, Invitation) ? invitation_link(:invite, employee) : t(:'employees.invitation_status.not_invited_yet')
    end
  end

  def invitation_link(type, employee)
    link_to ti(type, :'non-white' => true),
      invitation_url(type, employee),
      class: 'btn btn-mini pull-right', :remote => true
  end

  # TODO: let rails guess the urls by providing the persisted invitation of an employee or a new record
  def invitation_url(type, employee)
    if type == :invite
      new_organization_invitation_path(current_organization, invitation: { employee_id: employee.id })
    else
      edit_organization_invitation_path(current_organization, employee.invitation)
    end
  end

  def avatar(employee, version)
    html_options = { class: "avatar #{version}" }
    if employee.avatar?
      image_tag(employee.avatar.send(version).url, html_options)
    else
      image_tag(asset_path("#{version}_default_avatar.png"), html_options)
    end
  end
end
