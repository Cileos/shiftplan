# When /^I click on the button to (add|edit|delete) an? (.+)$/ do |method, klass|
#   link_id = "#{method}_#{klass.downcase.gsub(' ', '_')}"
#   $browser.link(:text, link_text_for(link_id)).click
#   $browser.wait
# end

Then /^I should see an? (.*) named "([^\"]*)"$/ do |klass, name|
  css_class = klass.downcase.gsub(/\s+/, ' ').gsub(/\s/, '_')
  name = /#{name}/ unless name.is_a?(Regexp)
  # element = page.getByXPath("html/body//*[@class=\"#{klass}\"]").get(0) # FIXME use find_element
  element = find_element(:class => klass)
  element.getTextContent.should match(name)
end

Then /^I should not see an? (.*) named "([^\"]*)"$/ do |klass, name|
  # css_class = klass.downcase.gsub(/\s+/, ' ').gsub(/\s/, '_')
  # elements = $browser.elements_by_xpath("//*[@class='#{css_class}']")  # TODO: improve xPath to only check descendants of /html/body
  # name = /#{name}/ unless name.is_a?(Regexp)
  # elements.any? { |element| eval(element.gsub('@io', '$server')).try(:text) =~ name rescue false }.should be_false
  # ($browser.div(:text, /#{name}/).html rescue nil).should be_nil
  flunk
end
