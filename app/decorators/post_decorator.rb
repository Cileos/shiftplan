class PostDecorator < ApplicationDecorator
  decorates :post

  def selector_for(name, resource=nil, extra=nil)
    case name
    when :posts
      'div.posts'
    when :post
      "div#post_#{resource.id}"
    else
      super
    end
  end

  def update_posts(post)
    select(:posts).refresh_html posts_list(post)
  end

  def update_post(post)
    select(:post, post).refresh_html post_details(post)
  end

  def posts_list(post)
    h.render('posts/posts_with_pagination', posts: h.paginated_posts(post.blog.posts))
  end

  def post_details(post)
    h.render('posts/post_details', post: post, truncation: false)
  end

  def respond
    unless errors.empty?
      prepend_errors_for(post)
    else
      clear_modal
      update_posts(post)
      update_post(post)
      update_flash
    end
  end
end
