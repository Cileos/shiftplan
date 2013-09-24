class FeedsController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_authorization_check

  respond_to :ics

  def upcoming
    @schedulings = current_user.schedulings.upcoming
  end

  private

  # Most feeds do not support sessions or HTTP auth, so we use User#private_token
  def current_user
    @current_user ||= User.where(email: params[:email]).where(private_token: params[:token]).first
  end
end
