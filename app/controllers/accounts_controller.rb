class AccountsController < InheritedResources::Base
  load_and_authorize_resource
  actions :all

  after_filter :setup_account, :only => :create

  protected

  def setup_account
    resource.setup
  end
end
