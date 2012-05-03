When /^#{capture_model}(?: with #{capture_fields})? is deleted$/ do |name, fields|
  model = find_model!(name, fields)
  model.destroy
end

