module PartialsSpecHelper
  # describe 'blog/posts/_list.html.haml'
  def described_partial_name
    subject.
      sub(%r~/_([^/]+)$~, '/\1'). # remove the partial-underscore
      sub(/(\.\w+){2}$/,'')       # remove format and template handler
  end

  def render_partial(opts={})
    render opts.reverse_merge(partial: described_partial_name)
  end
end

RSpec.configure do |config|
  config.include PartialsSpecHelper
end
