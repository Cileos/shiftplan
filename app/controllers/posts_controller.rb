class PostsController < InheritedResources::Base
  load_and_authorize_resource
  nested_belongs_to :organization, :blog

  before_filter :paginate, only: :index
  before_filter :check_if_post_was_deleted, only: :show

  respond_to :html, :js

  def paginated_posts(posts)
    posts.order('published_at desc').paginate(:page => params[:page], :per_page => 10)
  end
  helper_method :paginated_posts

  protected

  def paginate
    @posts = paginated_posts(@posts)
  end

  def check_if_post_was_deleted
    unless resource.present?
      flash[:info] = t(:'posts.post_deleted')
      redirect_to [current_organization, current_organization.company_blog, :posts]
    end
  end

  def resource
    if action_name == 'show'
      begin super; rescue; nil; end
    else
      super
    end
  end
end
