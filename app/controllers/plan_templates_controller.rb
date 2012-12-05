class PlanTemplatesController < InheritedResources::Base
  belongs_to :account
  belongs_to :organization
  load_and_authorize_resource

  def create
    # TODO: redirect to the  teams in week page for the plan template
    create! { [parent.account, parent] }
  end
end
