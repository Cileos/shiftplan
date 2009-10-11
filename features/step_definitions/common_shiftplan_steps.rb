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
  element = locate_shifts(date)
  drop(element)
end

When /^I drop onto the plan area$/ do
  element = locate_plan
  drop(element)
end

Then /^I should see an? (.*) named "([^\"]*)"$/ do |klass, name|
  css_class = klass.downcase.gsub(/\s+/, ' ').gsub(/\s/, '_')
  name = /#{name}/ unless name.is_a?(Regexp)
  # element = page.getByXPath("html/body//*[@class=\"#{klass}\"]").get(0) # FIXME use find_element
  element = find_element(:class => klass)
  element.getTextContent.should match(name)
end