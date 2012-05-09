When /^#{capture_model}(?: with #{capture_fields})? is deleted$/ do |name, fields|
  model = find_model!(name, fields)
  model.destroy
end

Given /^#{capture_model} has the avatar "([^"]*)"$/ do |model_name, avatar_path|
  model = model!(model_name)
  assert File.exists?(avatar_path), "could not find file #{avatar_path} for avatar"
  model.avatar = File.new(avatar_path)
  model.save!
end


