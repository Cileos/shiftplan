SprocketsApplication.use_page_caching = false unless Rails.env.production? || Rails.env.cucumber_ci?
