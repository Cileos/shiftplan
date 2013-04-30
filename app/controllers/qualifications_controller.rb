class QualificationsController < BaseController
  nested_belongs_to :account, :organization

  respond_to :html, :js

  def create
    create! { [parent.account, parent, :qualifications] }
  end

  def update
    update! { [parent.account, parent, :qualifications] }
  end

  private

  def end_of_association_chain
    super.default_sorting
  end
end
