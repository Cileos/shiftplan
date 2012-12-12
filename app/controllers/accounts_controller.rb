class AccountsController < InheritedResources::Base
  load_and_authorize_resource
  actions :show

  protected

  def find_current_account
    if params[:id]
      Account.find(params[:id])
    end
  end
end
