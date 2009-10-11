Given /^the following plans:$/ do |plans|
  plans.hashes.each do |attributes|
    Plan.create!(attributes)
  end
end

When /^I drag the (.*) "([^\"]*)"$/ do |type, name|
  element = case type
  when 'workplace'
    workplace = type.classify.constantize.find_by_name(name)
    find_element(:href => workplace_path(workplace)) do
      find_element(:div)
    end
  end
  drag(element) if element
end

When /^I drop onto the shifts area for day ([\d-]*)$/ do |date|
  element = find_element(:class => 'day', :'data-day' => date.gsub('-', '')) do
    find_element(:ul)
  end
  drop(element)
end

Then /^I should see a shift for the workplace "([^\"]*)" on ([\d-]*)$/ do |workplace_name, date|
  workplace = Workplace.find_by_name(workplace_name)
  shift = find_element(:class => 'day', :'data-day' => date.gsub('-', '')) do
    find_element(:li)
  end
  shift.getAttribute('data-workplace-id').should == workplace.id.to_s
  within(shift) { find_element(workplace.name) }.should_not be_nil
end
