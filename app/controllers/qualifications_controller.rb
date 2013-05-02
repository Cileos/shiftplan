class QualificationsController < BaseController
  nested_belongs_to :account, :organization

  respond_to :html, :js

  def create
    create! { [parent.account, parent, :qualifications] }
  end

  def update
    update! { [parent.account, parent, :qualifications] }
  end
end
