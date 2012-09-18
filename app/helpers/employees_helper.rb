module EmployeesHelper
  def invitation_status(employee)
    if employee.active?
      t(:'employees.invitation_status.active')
    elsif employee.invited?
      t(:'employees.invitation_status.invited', invited_at: l(employee.invitation.sent_at, format: :tiny))
    else
      t(:'employees.invitation_status.not_invited_yet')
    end
  end

  def invitation_status_link(employee)
    if !employee.active? && can?(:manage, Invitation)
      if can? :manage, employee.invitation
        invitation_link(:reinvite, employee)
      else
        invitation_link(:invite, employee)
      end
    end
  end

  def invitation_link(type, employee)
    link_to ti(type, :'non-white' => true),
      invitation_url(type, employee),
      class: 'btn btn-mini', :remote => true
  end

  # TODO: let rails guess the urls by providing the persisted invitation of an employee or a new record
  def invitation_url(type, employee)
    if type == :invite
      new_account_organization_invitation_path(current_account, current_organization, invitation: { employee_id: employee.id })
    else
      edit_account_organization_invitation_path(current_account, current_organization, employee.invitation)
    end
  end

  def avatar(user, employee, version)
    html_options = { class: "avatar #{version}" }
    if employee && employee.avatar?
      image_tag(employee.avatar.send(version).url, html_options)
    else
      gravatar(user, version, html_options)
    end
  end

  def gravatar(user, version, html_options)
    size = AvatarUploader.const_get("#{version.to_s.camelize}Size")
    gravatar_options = { default: 'mm', size: size }
    if user.present?
      image_tag user.gravatar_url(gravatar_options), html_options
    else
      image_tag User.new.gravatar_url(gravatar_options.merge(forcedefault: 'y')), html_options
    end
  end
end
