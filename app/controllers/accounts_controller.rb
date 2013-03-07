class AccountsController < InheritedResources::Base
  load_and_authorize_resource
  actions :all, except: [:new, :create]
end
