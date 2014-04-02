CarrierWave.configure do |config|
  config.storage = :file
  config.enable_processing = false
end

After('@fileupload') do
  FileUtils.rm_rf(Dir["#{Rails.root}/public/test_uploads"])
end
