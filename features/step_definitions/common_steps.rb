# If this file becomes to big, please consider tidying it up by splitting into
# other steps files

Given /^today is (.+)$/ do |timey|
  Timecop.travel Time.parse(timey)
end

After do
  Timecop.return
end

Given /^the situation of ([\w ]+)$/ do |situation|
  file = situation.downcase.underscore
  path = Rails.root/"features"/"situations"/"#{situation}.steps"

  path.should be_exist
  steps File.read(path)
end
