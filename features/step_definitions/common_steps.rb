# If this file becomes to big, please consider tidying it up by splitting into
# other steps files

Given /^today is ([^,]+)$/ do |timey|
  Timecop.travel Time.zone.parse(timey)
end

Given /^today is (\w+day), the (.+)$/i do |day, timey|
  time = Time.zone.parse(timey)
  time.strftime('%A').downcase.should == day.downcase
  Timecop.travel time
end

After do
  Timecop.return
end

# experiment: shared backgrounds. Put loose steps into
# features/situations/a_perfect_world.steps, so you can say
#   Given the situation of a perfect world
Given /^the situation of ([\w ]+)$/ do |situation|
  file = situation.downcase.gsub(/\s+/,'_')
  path = Rails.root/"features"/"situations"/"#{file}.steps"
  steps File.read(path)
end
