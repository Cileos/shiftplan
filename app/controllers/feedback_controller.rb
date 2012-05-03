class FeedbackController < InheritedResources::Base
  no_authentication_required
  load_and_authorize_resource

  respond_to :js

  def create
    create! do
      flash[:info] = t(:'feedback.thank_you')
      request.referer
    end
  end
end
