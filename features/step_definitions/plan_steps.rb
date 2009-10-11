Given /^the following plans:$/ do |plans|
  plans.hashes.each do |attributes|
    attributes = attributes.dup
    reformat_date!(attributes['start'])
    reformat_date!(attributes['end'])
    Plan.create!(attributes)
  end
end

