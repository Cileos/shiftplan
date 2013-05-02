class TeamsController < BaseController
  belongs_to :account
  belongs_to :organization

  respond_to :html, :js

  def update
    update! { [parent.account, parent, :teams] }
  end
end
