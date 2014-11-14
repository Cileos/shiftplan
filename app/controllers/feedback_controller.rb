class FeedbackController < BaseController
  skip_before_filter :authenticate_user!

  respond_to :js, :html

  def create
    create! do |success|
      success.html do
        flash[:notice] = t(:'feedback.thank_you')
        redirect_to root_url
      end
    end
  end
end
