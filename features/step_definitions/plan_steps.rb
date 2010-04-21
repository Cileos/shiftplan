Given /^the following plans:$/ do |plans|
  plans.hashes.each do |attributes|
    attributes = attributes.dup
    attributes['account'] = Account.find_by_name(attributes['account'])
    reformat_date!(attributes['start'])
    reformat_date!(attributes['end'])
    Plan.create!(attributes)
  end
end

# TODO: somehow merge this with the above to DRY it up
Given /^the following plans for "([^\"]*)":$/ do |account, plans|
  plans.hashes.each do |attributes|
    attributes = attributes.dup
    attributes['account'] = Account.find_by_name(account)
    reformat_date!(attributes['start'])
    reformat_date!(attributes['end'])
    Plan.create!(attributes)
  end
end

Then /^the following plans should be stored:$/ do |plans|
  plans.hashes.each do |attributes|
    attributes = attributes.dup
    attributes.each do |name, value|
      case name
      when 'start', 'end'
        attributes[name] = reformat_date!(value)
      when 'template'
        attributes[name] = eval(value)
      end
    end
    Plan.first(:conditions => attributes).should_not be_nil
  end
end
