class FeedsController < BaseController

  def upcoming
    render text: current_user.schedulings.upcoming.count.to_s
  end

  private

  # Most feeds do not support sessions or HTTP auth, so we use User#private_token
  def current_user
    @current_user ||= User.where(email: params[:email]).where(private_token: params[:token]).first
  end
end
