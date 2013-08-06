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

  def begin_of_association_chain
    authorize! :read, Plan
    current_organization
  end

  def collection
    end_of_association_chain.order(:name)
  end

  def redirect_to_valid_week
    VP::PlanRedirector.new(self, resource).redirect
  end
end
