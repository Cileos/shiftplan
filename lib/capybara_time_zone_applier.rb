# Capybara starts a server for all our @javascript tests which does not share
# the (randomly) set timezone of the main cucumber process. We write the zone
# to a tempfile so the server can pick it up upon every requests
class CapybaraTimeZoneApplier
  TmpFilePath = Rails.root.join('tmp/cucumber_timezone')
  def initialize(app)
    @app = app
  end

  def call(env)
    Time.use_zone read_zone do
      @app.call(env)
    end
  end

private
  def read_zone
    File.read(TmpFilePath)
  rescue
    self.class.current_name
  end

  def self.write(path=TmpFilePath)
    File.open(path, 'w') { |f| f.write current_name }
  end

  def self.clean(path=TmpFilePath)
    FileUtils.rm_f TmpFilePath
  end

  def self.current_name
    Time.current.time_zone.tzinfo.name
  end
end
