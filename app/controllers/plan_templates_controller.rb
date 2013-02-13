class PlanTemplatesController < InheritedResources::Base
  belongs_to :account
  belongs_to :organization
  load_and_authorize_resource

  def create
    create! { nested_resources_for(@plan_template) + [:teams_in_week] }
  end

  def update
    update! { nested_resources_for(current_organization) + [:plan_templates] }
  end
end
