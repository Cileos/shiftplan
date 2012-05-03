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

    # the role is bound to Employee, so we carry the employee around
    if employee = user.current_employee
      if employee.role.present?
        public_send "authorize_#{employee.role}", employee
      else
        authorize_employee employee
      end
    end

    unless user.new_record?
      authorize_signed_in
    end
    can :create, Feedback
  end

  def authorize_signed_in
    can :dashboard, User
  end

  def authorize_employee(employee)
    is_employee_of = { id: employee.organization_id }
<<<<<<< HEAD
    can :create, Comment, commentable: { plan: { organization: is_employee_of } }
    can :read,               Plan,         organization: is_employee_of
    can [:read, :create],    Post,         blog: { organization: is_employee_of }
    can [:update, :destroy], Post,         { author_id: employee.id }
    can :read,               Employee,     organization: is_employee_of
    can :read,               Team,         organization: is_employee_of
    can :read,               Scheduling,   plan: { organization: is_employee_of }
    can :read,               Organization, is_employee_of
    can [:read, :create],    Comment,      commentable: { blog: { organization: is_employee_of } }
    can [:read, :create],    Comment,      commentable: { plan: { organization: is_employee_of } }
    can [:destroy],          Comment,      { employee_id: employee.id }
  end

  def authorize_planner(planner)
    authorize_employee(planner)
    is_planner_of = { id: planner.organization_id }
    can [:read, :create, :update],  Employee,     organization: is_planner_of
    can :manage, 				            Team,         organization: is_planner_of
    can :manage,                    TeamMerge do |team_merge|
      planner.organization.teams.include?(team_merge.team) &&
        (!team_merge.other_team_id.present? ||
            planner.organization.teams.find_by_id(team_merge.other_team_id).present?)
    end
    can :manage,                    Plan,         organization: is_planner_of
    can :manage,                    Scheduling,   plan: { organization: is_planner_of }
    can :manage,                    Organization, is_planner_of
    can :manage,                    CopyWeek,     plan: { organization: is_planner_of }
    can :manage,                    Invitation,   employee: { organization: is_planner_of }
  end

  def authorize_owner(owner)
    authorize_planner(owner)
    # can :manage,                   Organization, id: owner.organization_id
  end

end
