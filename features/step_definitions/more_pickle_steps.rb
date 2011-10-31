Given /^#{capture_model} has the following (.+):$/ do |model, association, table|
  m = model!(model)
  table.hashes.each do |line|
    m.send(association).create! Factory.attributes_for(association.singularize, line)
  end
end

