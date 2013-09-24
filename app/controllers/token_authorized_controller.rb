# Inherit from this controller for resources fetched by clients that do not
# support sessions or HTTP auth.
#
# Params needed: :email, :private_token
#                 (must correspond with a User)
class TokenAuthorizedController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_authorization_check

  private

  def current_user
    @current_user ||= User.where(params.slice(:email, :private_token)).first
  end
end
