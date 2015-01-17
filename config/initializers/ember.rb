EmberCLI.configure do |c|
  ember_path = ENV['CLOCKWORK_EMBER_ROOT'] ||'/home/niklas/ember/clockwork.js/'
  c.app :frontend, path: ember_path
end
