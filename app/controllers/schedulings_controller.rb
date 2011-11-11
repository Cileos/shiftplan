class SchedulingsController < InheritedResources::Base
  nested_belongs_to :plan

  def create
    create! do |success, failure|
      success.html { redirect_to plan_path(resource.plan) }
    end
  end
end
