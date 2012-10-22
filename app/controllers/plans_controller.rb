class PlansController < InheritedResources::Base
  load_and_authorize_resource

  respond_to :html, :js

  def create
    create! do |success, failure|
      success.html { redirect_to_current_week }
    end
  end

  def show
    redirect_to_current_week
  end

  private

  def begin_of_association_chain
    authorize! :read, Plan
    current_organization
  end

  def collection
    end_of_association_chain.order(:name)
  end

  def redirect_to_current_week
    redirect_to current_week_path
  end

  def current_week_path
    account_organization_plan_employees_in_week_path(current_account, current_organization, resource, Date.today.year, Date.today.cweek)
  end
end
