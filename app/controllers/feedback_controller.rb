class FeedbackController < BaseController
  skip_before_filter :authenticate_user!

  respond_to :js, :html

  def create
    create! { root_url }
  end
end
