class QualificationsController < InheritedResources::Base
  belongs_to :account
  load_and_authorize_resource

  def create
    create! { [parent, :qualifications] }
  end

  def update
    update! { [parent, :qualifications] }
  end
end
