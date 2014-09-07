Rails.application.configure do
  # We don't want the default of everything that isn't js or css, because it pulls too many things in
  config.assets.precompile.shift

  # Explicitly register the extensions we are interested in compiling
  config.assets.precompile.push(Proc.new do |path|
    File.extname(path).in? [
      '.png',  '.gif', '.jpg', '.jpeg',         # Images
      '.ico',                                   # Icons
      '.cur',                                   # Cursors
      '.eot',  '.otf', '.woff', '.ttf', '.svg', # Fonts
    ]
  end)

  config.assets.precompile += %w(
   lib.js
   print.css
   iPad.css
   iPhone.css
   setup.js
  )

  unless Rails.env.production?
    config.assets.precompile += %w(
      test.js
      qunit.js
      test_helper.js
      qunit.css
      test_helper.css
    )
    config.assets.paths.append Rails.root.join('spec', 'stylesheets')
  end

end

NonStupidDigestAssets.whitelist = [
  'favicon.ico',
  'robots.txt',
  '422.html',
  '503.html',
  /\.eot$/,
  /\.otf$/,
  /\.woff$/,
  /\.ttf$/,
  /\.svg$/,
]
