class MilestonesController < InheritedResources::Base
  belongs_to :organization, :plan
  load_and_authorize_resource
  respond_to :json

  protected

  def collection
    @milestones ||= end_of_association_chain.includes(:tasks)
  end
end
