Given /^the following plans:$/ do |plans|
  plans.hashes.each do |attributes|
    Plan.create!(attributes)
  end
end