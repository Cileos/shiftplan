When /^I click on "([^\"]*)"$/ do |text|
  click_on(text)
end

When /^I drag the (.*) "([^\"]*)"$/ do |type, name|
  element = case type
  when 'workplace', 'qualification', 'employee'
    resource = type.classify.constantize.find_by_name(name)
    locate_element(:id => :sidebar) do |e|
      locate_element(:class => "#{type}_#{resource.id}") { locate_element(:div) }
    end
  else
    raise "drag not implemented: #{type}"
  end
  drag(element)
end

When /^I drop onto the plan area$/ do
  element = locate_body
  drop(element)
end

Then /^I should see an? (.*) named "([^\"]*)"$/ do |klass, name|
  css_class = klass.downcase.gsub(/\s+/, ' ').gsub(/\s/, '_')
  name = /#{name}/ unless name.is_a?(Regexp)
  element = locate_element(name, :class => klass)
  element.should_not be_nil
  element.inner_html.should match(name)
end