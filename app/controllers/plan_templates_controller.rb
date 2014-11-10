class PlanTemplatesController < BaseController
  nested_belongs_to :account, :organization
  before_action :authorize_source_of_schedulings, only: :create
  after_action -> { resource.filler.fill! }, only: :create, if: -> { resource.fill_from_n_items? }

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

  def permitted_params
    params.permit plan_template: [
      :name,
      :template_type,
      :fill_from_n_items,
      filler_attributes: [:plan_id, :year, :week]
    ]
  end

  def authorize_source_of_schedulings
    if plan = resource.filler.plan
      authorize! :read, plan
    end
  end
end
