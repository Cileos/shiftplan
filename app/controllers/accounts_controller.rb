class AccountsController < InheritedResources::Base
  load_and_authorize_resource
  actions :show
end
