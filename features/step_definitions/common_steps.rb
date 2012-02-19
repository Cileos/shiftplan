# If this file becomes to big, please consider tidying it up by splitting into
# other steps files

Given /^today is (.+)$/ do |timey|
  Timecop.travel Time.parse(timey)
end
