class TeamMergeController < InheritedResources::Base
  belongs_to :team, singleton: true

  load_and_authorize_resource

  def create
    create! { [team.organization.account, team.organization, :teams] }
  end

  private
  def team
    parent
  end
end
