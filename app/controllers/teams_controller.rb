class TeamsController < BaseController
  nested_belongs_to :account, :organization

  respond_to :html, :js
  tutorial 'team', only: [:index, :new]

  def update
    update! { [parent.account, parent, :teams] }
  end

private

  def permitted_params
    params.permit team: [
      :name,
      :shortcut,
      :color
    ]
  end
end
