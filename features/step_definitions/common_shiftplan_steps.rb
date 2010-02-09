When /^I click on the (.*) "([^\"]*)"$/ do |klass, name|
  css_class = klass.downcase.gsub(/\s+/, ' ').gsub(/\s/, '_')
  name = /#{name}/ unless name.is_a?(Regexp)
  click_on(name, :class => klass)
end

When /^I drag the (.*) "([^\"]*)"$/ do |type, name|
  element = case type
  when 'workplace', 'qualification', 'employee'
    resource = type.classify.constantize.find_by_name(name)
    drag(:div, :within => "#sidebar .#{type}_#{resource.id}")
  else
    raise "drag not implemented: #{type}"
  end
end

When /^I drop onto the plan area$/ do
  drop(:body)
end

When "I drop the element" do
  drop
end

Then /^I should see an? (.*) named "([^\"]*)"$/ do |klass, name|
  css_class = klass.downcase.gsub(/\s+/, ' ').gsub(/\s/, '_')
  # name = /#{name}/ unless name.is_a?(Regexp)
  element = locate(name, :class => css_class)
  element.should_not be_nil
  element.inner_html.should match(name)
end

Then /^I should not see an? (.*) named "([^\"]*)"$/ do |klass, name|
  css_class = klass.downcase.gsub(/\s+/, ' ').gsub(/\s/, '_')
  # name = /#{name}/ unless name.is_a?(Regexp)
  lambda { locate(name, :class => klass) }.should raise_error(Steam::ElementNotFound)
end
