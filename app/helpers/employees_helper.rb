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
    link_to ta(type),
      invitation_url(type, employee),
      class: 'button button-small', :remote => true
  end

  # TODO: let rails guess the urls by providing the persisted invitation of an employee or a new record
  def invitation_url(type, employee)
    if type == :invite
      new_account_organization_invitation_path(current_account, current_organization, invitation: { employee_id: employee.id })
    else
      edit_account_organization_invitation_path(current_account, current_organization, employee.invitation)
    end
  end

  def avatar(user, employee, version, html_classes = "")
    AvatarWidget.new(self, user, employee, version, class: html_classes).to_html
  end

  def avatar_with_caching(*a)
    @avatar_cache ||= {}
    @avatar_cache[a.map(&:to_param).join] ||= avatar_without_caching(*a)
  end

  alias_method_chain :avatar, :caching

end
