class FeedbackController < InheritedResources::Base
  skip_before_filter :authenticate_user!
  load_and_authorize_resource

  respond_to :js

  def create
    create! do
      flash[:notice] = t(:'feedback.thank_you')
      request.referer
    end
  end
end
