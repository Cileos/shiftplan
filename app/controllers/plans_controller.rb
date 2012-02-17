class PlansController < InheritedResources::Base
  before_filter :authenticate_user!

  def begin_of_association_chain
    current_user.organization
  end

  def show
    redirect_to_current_week
  end

  private

  def redirect_to_current_week
    redirect_to plan_week_path(resource, Date.today.cweek)
  end
end
