class TeamsController < BaseController
  belongs_to :account
  belongs_to :organization

  respond_to :html, :js

  def update
    update! { [parent.account, parent, :teams] }
  end

  private

  def end_of_association_chain
    super.default_sorting
  end
end
