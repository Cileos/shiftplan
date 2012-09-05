class MilestonesController < InheritedResources::Base
  belongs_to :organization, :plan
  load_and_authorize_resource
  respond_to :json
end
