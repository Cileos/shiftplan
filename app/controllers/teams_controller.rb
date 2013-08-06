class TeamsController < BaseController
  nested_belongs_to :account, :organization

  respond_to :html, :js

  def update
    update! { [parent.account, parent, :teams] }
  end
end
