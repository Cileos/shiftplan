Given /^the following plans:$/ do |plans|
  plans.hashes.each do |attributes|
    attributes = attributes.dup
    reformat_date!(attributes['start'])
    reformat_date!(attributes['end'])
    Plan.create!(attributes)
  end
end

When /^I drag the (.*) "([^\"]*)"$/ do |type, name|
  element = case type
  when 'workplace', 'qualification', 'employee'
    resource = type.classify.constantize.find_by_name(name)
    find_element(:id => :sidebar) do |e|
      find_element(:class => "#{type}_#{resource.id}") { find_element(:div) }
    end
  else
    raise "drag not implemented: #{type}"
  end
  drag(element)
end

When /^I drop onto the shifts area for day ([\d-]*)$/ do |date|
  drop(locate_shifts(date))
end

When /^I drop onto the plan area$/ do
  drop(locate_plan)
end

Then /^I should see a shift for the workplace "([^\"]*)" on ([\d-]*)$/ do |workplace_name, date|
  workplace = Workplace.find_by_name(workplace_name)
  shift = find_element(:class => 'day', :'data-day' => date.gsub('-', '')) do
    find_element(:li)
  end
  shift.getAttribute('data-workplace-id').should == workplace.id.to_s
  within(shift) { find_element(workplace.name) }.should_not be_nil
end
