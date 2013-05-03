class FeedbackController < BaseController
  skip_before_filter :authenticate_user!

  respond_to :js

  def create
    create! do
      flash[:notice] = t(:'feedback.thank_you')
      request.referer
    end
  end
end
