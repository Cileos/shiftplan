Given /^the following plans:$/ do |plans|
  plans.hashes.each do |attributes|
    attributes = attributes.dup
    attributes['account'] = Account.find_by_name(attributes['account'])
    reformat_date!(attributes['start'])
    reformat_date!(attributes['end'])
    Plan.create!(attributes)
  end
end

