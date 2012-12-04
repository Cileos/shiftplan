class QualificationsController < InheritedResources::Base
  belongs_to :account
  belongs_to :organization
  load_and_authorize_resource

  def create
    create! { [parent.account, parent, :qualifications] }
  end
end
