class PlansController < BaseController
  nested_belongs_to :account, :organization
  respond_to :html, :js
  tutorial 'team', only: [:index, :new]

  def create
    create! do |success, failure|
      success.html { redirect_to_valid_week }
    end
  end

  def destroy
    destroy! do |success, failure|
      success.html { redirect_to list_of_plans_path }
    end
  end

  def show
    redirect_to_valid_week
  end

  private

  def collection
    end_of_association_chain.order(:name)
  end

  def redirect_to_valid_week
    VP::PlanRedirector.new(self, resource).redirect
  end

  def permitted_params
    params.permit plan: [
      :name,
      :description,
      :duration,
      :starts_at,
      :ends_at
    ]
  end

  def list_of_plans_path
    nested_resources_for(current_organization) + [:plans]
  end
end
