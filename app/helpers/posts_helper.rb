module PostsHelper
  def company_blog_posts
    @posts ||= company_blog.posts.order('published_at desc').paginate(:page => params[:page], :per_page => 3)
  end

  def company_blog
    @company_blog ||= current_organization.company_blog
  end
end
