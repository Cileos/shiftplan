class PlansController < BaseController
  nested_belongs_to :account, :organization
  respond_to :html, :js

  def create
    create! do |success, failure|
      success.html { redirect_to_valid_week }
    end
  end

  def destroy
    destroy! do |success, failure|
      success.html { redirect_to (nested_resources_for(current_organization) + [:plans]) }
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
    params.require(:plan).permit(
      :name,
      :description,
      :duration,
      :starts_at,
      :ends_at
    )
  end
end
