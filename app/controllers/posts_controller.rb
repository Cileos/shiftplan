class PostsController < InheritedResources::Base
  load_and_authorize_resource
  nested_belongs_to :organization, :blog

  before_filter :paginate, only: :index

  respond_to :html, :js

  def paginated_posts(posts)
    posts.order('published_at desc').paginate(:page => params[:page], :per_page => 10)
  end
  helper_method :paginated_posts

  protected

  def paginate
    @posts = paginated_posts(@posts)
  end
end
