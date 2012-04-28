# If this file becomes to big, please consider tidying it up by splitting into
# other steps files

Given /^today is (.+)$/ do |timey|
  Timecop.travel Time.zone.parse(timey)
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

Then /^I should see the avatar "([^"]*)" for the employee "([^"]*)"$/ do |file_name, employee_name|
  employee = Employee.find_by_first_name_and_last_name(employee_name.split[0], employee_name.split[1])
  image_tag = page.find("img#avatar_#{employee.id}")
  assert image_tag['src'].split('/').last.include?(file_name), "No image tag with src including '#{file_name}' found"
  path = [Rails.root, 'features', image_tag['src'].split('/features/')[1]].join('/')
  assert File.exists?(path), "File '#{path}' does not exist."
end

