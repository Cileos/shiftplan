class QualificationsController < InheritedResources::Base
  nested_belongs_to :account, :organization
  load_and_authorize_resource

  respond_to :html, :js

  def create
    create! { [parent.account, parent, :qualifications] }
  end

  def update
    update! { [parent.account, parent, :qualifications] }
  end
end
