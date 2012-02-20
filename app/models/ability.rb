class Ability
  include CanCan::Ability

  def initialize(current_user)
    user = current_user || User.new # guest user (not logged in)

    user.roles.each do |role|
      public_send "authorize_#{role}", user
    end
  end

  def authorize_planner(planner)
    can :dashboard , User
    can :manage    , Organization , user_id: planner.id
    can :manage    , Employee     , organization: { planner_id: planner.id }
    can :manage    , Plan         , organization: { planner_id: planner.id }
    can :manage    , Scheduling   , plan: { organization: { planner_id: planner.id }}
  end
end
