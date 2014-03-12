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

Given /^the ([_\w]+)(?: attribute)? of #{capture_model} (?:are|is) changed to #{capture_value}$/ do |attribute, model, value|
  model = model!(model)

  value = case value
    when /^[+-]?[0-9_]+(\.\d+)?$/
      value.to_f
    else
      eval(value)
    end

  model.send("#{attribute}=", value)
  model.save!
end

And /^#{capture_model} is the owner of #{capture_model}$/ do |employee, account|
  account = model!(account)
  account.owner_id = model!(employee).id
  account.save!
end
