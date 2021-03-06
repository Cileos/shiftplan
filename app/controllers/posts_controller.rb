class PostsController < BaseController
  nested_belongs_to :account, :organization, :blog

  before_filter :check_if_post_was_deleted, only: :show

  respond_to :html, :js

  protected

  def collection
    @posts = end_of_association_chain.order('published_at desc').page(params[:page]).per(10)
  end

  # FIXME why not just rescue from ActiveRecord::RecordNotFound ??
  def check_if_post_was_deleted
    unless resource.present?
      flash[:notice] = t(:'posts.post_deleted')
      redirect_to [current_account, current_organization, current_organization.company_blog, :posts]
    end
  end

  def resource
    if action_name == 'show'
      begin super; rescue; nil; end
    else
      super
    end
  end

  def permitted_params
    params.permit post: [
      :title,
      :body,
      :author_id, # TODO better assign author in controller to prevent HACKs
    ]
  end
end
