class TeamsController < InheritedResources::Base
  belongs_to :account
  belongs_to :organization
  load_and_authorize_resource

  def update
    update! { [parent.account, parent, :teams] }
  end
end
