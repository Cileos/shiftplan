class CommentsController < InheritedResources::Base
  belongs_to :post # , polymorphic: true, optional: false
  load_and_authorize_resource

  actions :create, :destroy
  respond_to :js

  private

  def build_resource
    @comment = Comment.build_from( parent, current_user.current_employee, params[:comment] )
  end
end

