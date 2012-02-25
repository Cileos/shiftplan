class TeamMergeController < InheritedResources::Base
  belongs_to :team, singleton: true

  load_and_authorize_resource

  def create
    create! { teams_url }
  end
end
