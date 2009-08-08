Then /^I should see an? (.*) named "([^\"]*)"$/ do |klass, name|
  css_class = klass.downcase.gsub(/\s+/, ' ').gsub(/\s/, '_')
  elements = $browser.elements_by_xpath("//*[@class='#{css_class}']")  # TODO: improve xPath to only check descendants of /html/body
  name = /#{name}/ unless name.is_a?(Regexp)
  elements.any? { |element| eval(element.gsub('@io', '$server')).try(:text) =~ name rescue false }.should be_true
end

Then /^I should not see an? (.*) named "([^\"]*)"$/ do |klass, name|
  css_class = klass.downcase.gsub(/\s+/, ' ').gsub(/\s/, '_')
  elements = $browser.elements_by_xpath("//*[@class='#{css_class}']")  # TODO: improve xPath to only check descendants of /html/body
  name = /#{name}/ unless name.is_a?(Regexp)
  elements.any? { |element| eval(element.gsub('@io', '$server')).try(:text) =~ name rescue false }.should be_false
end