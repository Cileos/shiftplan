EmberCLI.configure do |c|
  ember_root = ENV['CLOCKWORK_EMBER_ROOT']
  if !ember_root.nil? && !ember_root.empty?
    c.app :frontend, path: ember_root, build_timeout: 10
  end
end
