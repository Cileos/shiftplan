# We want to pipe everythign through the asset pipeline. Some external CSS uses
# relative paths that break in the AP, so we rewrite them.

Rails.application.assets.register_preprocessor 'text/css', Sprockets::UrlRewriter
