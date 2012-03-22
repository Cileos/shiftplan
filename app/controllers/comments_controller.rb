class CommentsController < InheritedResources::Base
  # TODO fails in polymorphic mode
  belongs_to :scheduling # , polymorphic: true, optional: false
  load_and_authorize_resource

  actions :create
  respond_to :js

  private

  def build_resource
    @comment = Comment.build_from( parent, current_user, params[:comment] )
  end
end
