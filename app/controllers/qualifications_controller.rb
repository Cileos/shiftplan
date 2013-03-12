class QualificationsController < InheritedResources::Base
  belongs_to :account
  load_and_authorize_resource

  def create
    create! { [current_account, current_organization, :qualifications] }
  end

  def update
    update! { [current_account, current_organization, :qualifications] }
  end
end
