class PlanTemplatesController < InheritedResources::Base
  belongs_to :account
  belongs_to :organization
  load_and_authorize_resource

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
end
