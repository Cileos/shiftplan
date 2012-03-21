class Ability
  include CanCan::Ability

  def initialize(current_user)
    user = current_user || User.new # guest user (not logged in)

    # the role is bound to Employee, so we carry the employee around
    if employee = user.current_employee
      if employee.role.present?
        public_send "authorize_#{employee.role}", employee
      else
        authorize_employee employee
      end
    else
      # no employee => nuffin allowed
    end

    unless user.new_record?
      authorize_signed_in
    end

  end

  def authorize_signed_in
    can :dashboard, User
  end

  def authorize_employee(employee)
    is_employee_of = { id: employee.organization_id }
    can :read,  Plan,       organization: is_employee_of
    can :read, Employee,   organization: is_employee_of
    can :read, Team,      organization: is_employee_of
    can :read,  Scheduling, plan: { organization: is_employee_of }
  end

  def authorize_planner(planner)
    authorize_employee(planner)
    is_planner_of = { id: planner.organization_id }
    can :dashboard,                 User
    can [:read, :create, :update], Employee,     organization: is_planner_of
    can :manage, 				            Team,         organization: is_planner_of
    can :manage,                    TeamMerge,    team: { organization: is_planner_of }
    can :manage,                    Plan,         organization: is_planner_of
    can :manage,                    Scheduling,   plan: { organization: is_planner_of }
    can :manage,                    Organization, is_planner_of
    can :manage,                    CopyWeek,     plan: { organization: is_planner_of }
  end

  def authorize_owner(owner)
    authorize_planner(owner)
    # can :manage,                   Organization, id: owner.organization_id
  end

end
