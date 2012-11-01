class Ability
  #
  # WARNING
  #
  # If your defined abilities are not applied, make sure an :organization_id is
  # included in the URL of the current action, else User#current_employee is
  # not set and we cannot determine permissions
  #
  include CanCan::Ability

  def initialize(current_user)
    user = current_user || User.new # guest user (not logged in)

    alias_action :multiple, to: :read
    SchedulingFilterDecorator::Modes.each do |mode|
      alias_action mode, to: :read
    end

    # the role is bound to Employee, so we carry the employee around
    if employee = user.current_employee
      if employee.role.present?
        public_send "authorize_#{employee.role}", employee
      else
        authorize_employee employee
      end
    elsif user.persisted?
      authorize_signed_in(user)
    end
    can :create, Feedback
  end

  def authorize_signed_in(user)
    can :dashboard, User
    can :read, Account do |account|
      user.accounts.include?(account)
    end
    can [:read, :update], Employee do |employee|
      user == employee.user
    end
    can [:read, :update], User do |u|
      user == u
    end
  end

  def authorize_employee(employee)
    authorize_signed_in(employee.user)

    can :read, Account do |account|
      employee.account == account
    end
    can :read, Organization do |organization|
      employee.organizations.include?(organization)
    end
    can :read, Employee do |e|
      # TODO
      e.account == employee.account
    end
    can :read, Plan do |plan|
      employee.organizations.include?(plan.organization)
    end
    can :read, Scheduling do |scheduling|
      employee.organizations.include?(scheduling.plan.organization)
    end
    can :read, Team do |team|
      employee.organizations.include?(team.organization)
    end
    can [:read, :create], Post do |post|
      employee.organizations.include?(post.blog.organization)
    end
    # must not be copied to authorize_planner
    can [:update, :destroy], Post do |post|
      post.author == employee
    end
    can [:read, :create], Comment do |comment|
      commentable = comment.commentable
      if commentable.respond_to?(:blog) # comment on a post
        employee.organizations.include?(commentable.blog.organization)
      elsif commentable.respond_to?(:plan) # comment on a scheduling
        employee.organizations.include?(commentable.plan.organization)
      else
        false
      end
    end
    # must not be copied to authorize_planner
    can [:destroy], Comment do |comment|
      comment.employee == employee
    end
  end

  # As a planner or an owner must not have a membership for an organization of
  # his account to do things, a lot of abilities have to be copied from
  # authorize_employee and redefined by comparing the account of the
  # owner/planner with the account of the entities like Plan. The definition of
  # ablities might change soon in the future when we need to introduce roles on
  # memberships, too.
  def authorize_planner(planner)
    account = planner.account

    can [:read, :update], Organization do |organization|
      account == organization.account
    end
    can :manage, Employee do |employee|
      (employee.account.nil? || account == employee.account) &&
        (employee.organization_id.nil? || account.organizations.map(&:id).include?(employee.organization_id.to_i))
    end
    can :manage, Plan do |plan|
      account == plan.organization.account
    end
    can :manage, Scheduling do |scheduling|
      account == scheduling.plan.organization.account
    end
    can :manage, CopyWeek do |copy_week|
      account == copy_week.plan.organization.account
    end
    can :manage, Team do |team|
      account == team.organization.account
    end
    can :manage, TeamMerge do |team_merge|
      (team_merge.team_id.blank? || account == team_merge.team.try(:organization).try(:account)) &&
        (team_merge.other_team_id.blank? || account == team_merge.other_team.try(:organization).try(:account)) &&
        (team_merge.new_team_id.blank? || account == team_merge.new_team.try(:organization).try(:account))
    end
    can [:read, :create], Post do |post|
      account == post.blog.organization.account
    end
    can [:read, :create], Comment do |comment|
      commentable = comment.commentable
      if commentable.respond_to?(:blog) # comment on a post
        account == commentable.blog.organization.account
      elsif commentable.respond_to?(:plan) # comment on a scheduling
        account == commentable.plan.organization.account
      else
        false
      end
    end
    can :manage, Invitation do |invitation|
      account == invitation.employee.account &&
        account == invitation.organization.account
    end
    can :manage, Milestone do |milestone|
      account == milestone.plan.organization.account
    end
    can :manage, Task do |task|
      account == task.milestone.plan.organization.account
    end

    authorize_employee(planner)
  end

  def authorize_owner(owner)
    account = owner.account

    can [:update], Account do |a|
      account == a
    end
    can :manage, Organization do |organization|
      account == organization.account
    end

    authorize_planner(owner)
  end
end
