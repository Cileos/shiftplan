class PostsController < InheritedResources::Base
  load_and_authorize_resource
  nested_belongs_to :organization, :blog

  before_filter :check_if_post_was_deleted, only: :show

  respond_to :html, :js

  def paginated_posts(posts)
  end
  helper_method :paginated_posts

  protected

  def collection
    @posts ||= end_of_association_chain.order('published_at desc').paginate(:page => params[:page], :per_page => 10)
  end

  # FIXME why not just rescue from ActiveRecord::RecordNotFound ??
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
