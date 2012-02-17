Then /^the selected "([^"]*)" should be "([^"]*)"$/ do |field, value|
  field_labeled(field).native.xpath(".//option[@selected = 'selected']").inner_html.should =~ /#{value}/
end
