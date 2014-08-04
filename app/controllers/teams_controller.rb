class TeamsController < BaseController
  nested_belongs_to :account, :organization

  respond_to :html, :js

  def update
    update! { [parent.account, parent, :teams] }
  end

private

  def permitted_params
    params.require(:team).permit(
      :name,
      :shortcut,
      :color
    )
  end
end
