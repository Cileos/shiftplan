class PlanTemplatesController < InheritedResources::Base
  belongs_to :account
  belongs_to :organization
  load_and_authorize_resource

  respond_to :html, :js

  def create
    create! do |success, failure|
      success.html do
        redirect_to nested_resources_for(@plan_template) + [:teams_in_week]
      end
    end
  end

  def update
    update! do |success, failure|
      success.html do
        redirect_to nested_resources_for(current_organization) + [:plan_templates]
      end
    end
  end

  private

  def end_of_association_chain
    super.default_sorting
  end
end
