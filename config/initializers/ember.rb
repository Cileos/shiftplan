EmberCLI.configure do |c|
  ember_path = ENV['CLOCKWORK_EMBER_ROOT']
  if !ember_path.nil? && !ember_path.empty?
    c.app :frontend, path: ember_path
  end
end
