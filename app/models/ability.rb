class Ability
  #
  # WARNING
  #
  # If your defined abilities are not applied, make sure an :organization_id is
  # included in the URL of the current action, else User#current_employee is
  # not set and we cannot determine permissions
  #
  include CanCan::Ability

  def initialize(current_user_with_context)
    user = current_user_with_context || User.new # guest user (not logged in)

    alias_action :multiple, to: :read
    SchedulingFilterDecorator.supported_modes.each do |mode|
      alias_action mode, to: :read
    end

    if employee = user.current_employee
      if employee.owner?
        # The user is in the scope of an account.
        authorize_owner(user)
      elsif membership = user.current_membership
        # The user is in the scope of an organization.
        if membership.role.present?
          public_send "authorize_#{membership.role}", user
        else
          authorize_employee user
        end
      else
        authorize_employee user
      end
    elsif user.persisted?
      # The user is not in the scope of an account. (A user can have multiple
      # accounts)
      authorize_signed_in(user)
    else # the user is not logged in
      authorize_anonymous
    end
    can :create, Feedback
  end

  def authorize_signed_in(user)
    can :dashboard, User
    can [:read, :update], Notification::Base, employee: { user_id: user.id }
    can :read, Account do |account|
      user.accounts.include?(account)
    end
    can :update, Account do |account|
      employee = user.employee_for_account(account)
      employee && employee.owner?
    end
    can :create, Account do |account|
      account.user == user
    end
    can :read_report, Account do |account|
      employee = user.employee_for_account(account)
      employee.owner?
    end
    can :read, Organization do |organization|
      employee = user.employee_for_account(organization.account)
      employee && employee.organizations.include?(organization)
    end
    can [:update, :create, :destroy], Organization do |organization|
      employee = user.employee_for_account(organization.account)
      employee && employee.owner?
    end
    can [:update_profile], Employee do |employee|
      user == employee.user
    end
    can [:read, :update, :update_profile], User do |u|
      user == u
    end

    can :show, Conflict do |conflict|
      user == conflict.provoker.employee.user
    end

    can [:read, :create, :destroy], IcalExport do |ie|
      user == ie.user
    end

    can :update, Volksplaner::Undo::Step
  end

  def authorize_employee(user)
    authorize_signed_in(user)
    curr_employee = user.current_employee

    can :read, Plan do |plan|
      curr_employee.organizations.include?(plan.organization)
    end
    can :read, Scheduling do |scheduling|
      curr_employee.organizations.include?(scheduling.plan.organization)
    end
    can [:read, :create], Post do |post|
      curr_employee.organizations.include?(post.blog.organization)
    end
    # must not be copied to authorize_planner
    can [:update, :destroy], Post do |post|
      curr_employee == post.author
    end
    can [:read, :create], Comment do |comment|
      commentable = comment.commentable
      if commentable.respond_to?(:blog) # comment on a post
        curr_employee.organizations.include?(commentable.blog.organization)
      elsif commentable.respond_to?(:plan) # comment on a scheduling
        curr_employee.organizations.include?(commentable.plan.organization)
      else
        false
      end
    end
    # must not be copied to authorize_planner
    can [:destroy], Comment do |comment|
      curr_employee == comment.employee
    end
    can :read, Milestone do |milestone|
      curr_employee.organizations.include?(milestone.plan.organization)
    end
    can :read, Task do |task|
      curr_employee.organizations.include?(task.milestone.plan.organization)
    end
  end

  # As a planner or an owner must not have a membership for an organization of
  # his account to do things, a lot of abilities have to be copied from
  # authorize_employee and redefined by comparing the account of the
  # owner/planner with the account of the entities like Plan. The definition of
  # ablities might change soon in the future when we need to introduce roles on
  # memberships, too.
  def authorize_planner(user)
    curr_employee     = user.current_employee
    curr_account      = curr_employee.account
    curr_organization = user.current_membership.try(:organization)

    can [:read], Organization do |organization|
      curr_account == organization.account
    end
    can [:adopt, :search], Employee
    can [:read], Employee do |employee|
      employee.organizations.include?(curr_organization)
    end
    can [:update, :create], Employee do |employee|
      (
        !employee.owner? || curr_employee == employee
      ) &&
        # organization_id is a virtual attribute of employee and is used to
        # create the membership for the current organization after create of the
        # employee. So the following line makes sure that memberships for orgs
        # of other account can not be created.
      (
        employee.organization_id.nil? ||
        employee.organization_id.to_i == curr_organization.id
      ) &&
      (
        employee.account.nil? ||
        curr_account == employee.account
      )
    end
    can :update_role, Employee do |employee|
      curr_employee != employee && # no one can update her/his own role
        curr_organization.employees.include?(employee)
    end
    can :manage, Plan do |plan|
      curr_organization == plan.organization
    end
    can :manage, Scheduling do |scheduling|
      curr_organization == scheduling.plan.organization
    end
    can :manage, Shift do |shift|
      curr_organization == shift.plan_template.organization
    end
    can :manage, CopyWeek do |copy_week|
      curr_organization == copy_week.plan.organization
    end
    can :manage, ApplyPlanTemplate do |apply_plan_template|
      curr_organization == apply_plan_template.plan.organization
    end
    can :manage, Team do |team|
      curr_organization == team.organization
    end
    can :manage, Qualification do |qualification|
      curr_account == qualification.account
    end
    can :manage, PlanTemplate do |plan_template|
      curr_organization == plan_template.organization
    end
    can :manage, TeamMerge do |team_merge|
      (team_merge.team_id.blank? || curr_organization == team_merge.team.try(:organization)) &&
        (team_merge.other_team_id.blank? || curr_organization == team_merge.other_team.try(:organization)) &&
        (team_merge.new_team_id.blank? || curr_organization == team_merge.new_team.try(:organization))
    end
    can [:read, :create], Post do |post|
      curr_organization == post.blog.organization
    end
    can [:read, :create], Comment do |comment|
      commentable = comment.commentable
      if commentable.respond_to?(:blog) # comment on a post
        curr_organization == commentable.blog.organization
      elsif commentable.respond_to?(:plan) # comment on a scheduling
        curr_organization == commentable.plan.organization
      else
        false
      end
    end
    can :manage, Invitation do |invitation|
      curr_account == invitation.employee.account &&
        curr_organization == invitation.organization
    end
    can :manage, Milestone do |milestone|
      curr_organization == milestone.plan.organization
    end
    can :manage, Task do |task|
      curr_organization == task.milestone.plan.organization
    end

    can :show, Conflict do |conflict|
      current_organization == conflict.provoker.plan.organization
    end

    authorize_owner_and_planner(user)
    authorize_employee(user)
  end

  def authorize_owner(user)
    owner         = user.current_employee
    curr_account  = owner.account


    can [:update], Account do |a|
      curr_account == a
    end
    can :manage, Organization do |organization|
      curr_account == organization.account
    end
    can [:adopt, :search], Employee
    can [:read], Employee do |employee|
      curr_account == employee.account
    end
    can [:update, :create], Employee do |employee|
      # organization_id is a virtual attribute of employee and is used to create the
      # membership for the current organization after create of the employee. So the
      # following line makes sure that memberships for orgs of other account can not be
      # created.
      (
        employee.organization_id.nil? || # e.g. on employees/index
        curr_account.organizations.map(&:id).include?(employee.organization_id.to_i)
      ) &&
      (
        employee.account.nil? ||
        curr_account == employee.account
      )
    end
    can :update_role, Employee do |employee|
      owner != employee && # no one can update her/his own role
        employee.account == curr_account
    end
    can :manage, Plan do |plan|
      curr_account == plan.organization.account
    end
    can :manage, Scheduling do |scheduling|
      curr_account == scheduling.plan.organization.account
    end
    can :manage, Shift do |shift|
      curr_account == shift.plan_template.organization.account
    end
    can :manage, CopyWeek do |copy_week|
      curr_account == copy_week.plan.organization.account
    end
    can :manage, ApplyPlanTemplate do |apply_plan_template|
      curr_account == apply_plan_template.plan.organization.account
    end
    can :manage, Team do |team|
      curr_account == team.organization.account
    end
    can :manage, Qualification do |qualification|
      curr_account == qualification.account
    end
    can :manage, PlanTemplate do |plan_template|
      curr_account == plan_template.organization.account
    end
    can :manage, TeamMerge do |team_merge|
      (team_merge.team_id.blank? || curr_account == team_merge.team.try(:organization).try(:account)) &&
        (team_merge.other_team_id.blank? || curr_account == team_merge.other_team.try(:organization).try(:account)) &&
        (team_merge.new_team_id.blank? || curr_account == team_merge.new_team.try(:organization).try(:account))
    end
    can [:read, :create], Post do |post|
      curr_account == post.blog.organization.account
    end
    can [:read, :create], Comment do |comment|
      commentable = comment.commentable
      if commentable.respond_to?(:blog) # comment on a post
        curr_account == commentable.blog.organization.account
      elsif commentable.respond_to?(:plan) # comment on a scheduling
        curr_account == commentable.plan.organization.account
      else
        false
      end
    end
    can :manage, Invitation do |invitation|
      curr_account == invitation.employee.account &&
        curr_account == invitation.organization.account
    end
    can :manage, Milestone do |milestone|
      curr_account == milestone.plan.organization.account
    end
    can :manage, Task do |task|
      curr_account == task.milestone.plan.organization.account
    end

    can :show, Conflict do |conflict|
      current_organization == conflict.provoker.plan.organization
    end

    can :read_report, Account do |account|
      curr_account == account
    end

    authorize_owner_and_planner(user)
    authorize_employee(user)
  end

  private

  # What owner and planner have in common
  def authorize_owner_and_planner(user)
    curr_employee     = user.current_employee
    curr_account      = curr_employee.account
    curr_organization = user.current_membership.try(:organization)

    can :manage, AttachedDocument do |doc|
      curr_organization == doc.plan.organization
    end
  end

  def authorize_anonymous
    can :manage, Signup
  end
end
