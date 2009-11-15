Given /^the following plans:$/ do |plans|
  plans.hashes.each do |attributes|
    attributes = attributes.dup
    attributes['account'] = Account.find_by_name(attributes['account'])
    reformat_date!(attributes['start_date'])
    reformat_date!(attributes['end_date'])
    Plan.create!(attributes)
  end
end

# TODO: somehow merge this with the above to DRY it up
Given /^the following plans for "([^\"]*)":$/ do |account, plans|
  plans.hashes.each do |attributes|
    attributes = attributes.dup
    attributes['account'] = Account.find_by_name(account)
    reformat_date!(attributes['start_date'])
    reformat_date!(attributes['end_date'])
    Plan.create!(attributes)
  end
end
