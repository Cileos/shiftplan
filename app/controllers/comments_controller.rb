# Inherit from here for each new commentable model.
#
# Inherited Resources fails to find the parent in polymorpic mode
class CommentsController < InheritedResources::Base
  def self.inherited(child)
    super
    child.class_eval do
      actions :create, :destroy
      defaults :resource_class => Comment, :collection_name => 'comments', :instance_name => 'comment'
      load_and_authorize_resource class: Comment

      respond_to :js
    end
  end

  protected

  def comment_params
    params.require(:comment).permit(
      :parent_id,
      :body
    )
  end

  private

  def build_resource
    @comment = Comment.build_from( parent, current_employee, comment_params )
  end
end
