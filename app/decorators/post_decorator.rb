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

  def update_posts
    select(:posts).html posts_list
  end

  def update_post(post)
    select(:post, post).html post_details(post)
  end

  def posts_list
    h.render('posts/list', posts: h.company_blog_posts)
  end

  def post_details(post)
    h.render('posts/post', post: post, truncation: false)
  end

  def respond
    unless errors.empty?
      prepend_errors_for(post)
    else
      hide_modal
      update_posts
      update_post(post)
      update_flash
    end
  end
end
