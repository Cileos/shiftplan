class TasksController < InheritedResources::Base
  before_filter :inject_milestone_id_into_params
  belongs_to :organization, :plan, :milestone
  load_and_authorize_resource
  respond_to :json

  private

  # Ember-data cannot nest resources, but always send us the parent_id as attribute to the resource
  # TODO: remove when Ember-data supports resource nesting
  def inject_milestone_id_into_params
    if task = params[:task]
      params[:milestone_id] ||= task[:milestone_id]
    end
  end

end
