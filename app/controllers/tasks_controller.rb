class TasksController < BaseController
  before_filter :inject_milestone_id_into_params
  nested_belongs_to :account, :organization, :plan

  belongs_to :milestone, optional: true
  respond_to :json

  private

  # Ember-data cannot nest resources, but always send us the parent_id as attribute to the resource
  # TODO: remove when Ember-data supports resource nesting
  def inject_milestone_id_into_params
    if (task = params[:task]) and task[:milestone_id]
      params[:milestone_id] ||= task[:milestone_id]
    end
  end

end
