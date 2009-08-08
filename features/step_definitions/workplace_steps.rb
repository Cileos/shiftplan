Given /^the following workplaces:$/ do |workplaces|
  workplaces.hashes.each do |workplace_attributes|
    Workplace.create!(workplace_attributes)
  end
end