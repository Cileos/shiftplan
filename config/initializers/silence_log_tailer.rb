Rails::Rack::LogTailer.class_eval do
  def tail!
    # stfu
  end
end if ENV['USER'] == 'sven'