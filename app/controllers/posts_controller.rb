class PostsController < InheritedResources::Base
  load_and_authorize_resource
  nested_belongs_to :organization, :blog

  respond_to :html, :js

  def create
    create! do |success, failure|
      success.html { organization_path(current_organization) }
    end
  end

  def destroy
    destroy! { organization_path(current_organization) }
  end
end
