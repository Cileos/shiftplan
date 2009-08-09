Given /^the following allocations:$/ do |allocations|
  allocations.hashes.each do |attributes|
    first_name, last_name = attributes['employee'].split(' ')
    employee = Employee.find_or_create_by_first_name_and_last_name(first_name, last_name)
    workplace = Workplace.find_or_create_by_name(attributes['workplace'])
    requirement = Requirement.find_by_workplace_id(workplace.id)
    Allocation.create!(
      :employee => employee,
      :workplace => workplace,
      :start => attributes['start'],
      :end => attributes['end'],
      :requirement => requirement
    )
  end
end

Then /^I should see an? (.+) requirement for the "([^\"]*)" containing (\d+) employees?$/ do |status, workplace, quantity|
  status.gsub!(' ', '_')
  path = "//*[contains(@class, 'requirement')]"
  elements = elements_by_xpath(path)
  workplace = Workplace.find_by_name(workplace)
  elements.any? do |element|
    # element.attribute_value(:class) =~ /workplace_#{workplace.id}/ &&
      element.attribute_value(:class) =~ /#{status}/ &&
      element.attribute_value(:'data-quantity') == quantity.to_s
  end.should be_true
end

When /^I doubleclick the cell referencing the "([^\"]*)" on "([^\"]*)" at "([^\"]*)"$/ do |workplace, date, time|
  date = Date.parse(date)
  workplace = Workplace.find_by_name(workplace)
  path = "//*[@data-day='#{date.strftime('%Y-%m-%d')}']//*[@data-time='#{time.to_s}']"
  element = elements_by_xpath(path).first
  element.double_click
end

Then /^I should see an? (.+) requirement for (\d+) employees? at the "([^\"]*)" on "([^\"]*)" from "([^\"]*)" to "([^\"]*)"$/ do |status, quantity, workplace, date, start_time, end_time|
  status.gsub!(' ', '_')
  date = Date.parse(date)
  workplace = Workplace.find_by_name(workplace)

  # path = "//*[@data-day='#{date.strftime('%Y-%m-%d')}']//*[@data-workplace-id='#{workplace.id}']//*[contains(@class, 'requirement')]"
  path = "//*[@data-day='#{date.strftime('%Y-%m-%d')}']//*[@data-workplace-id]//*[contains(@class, 'requirement')]"
  elements_by_xpath(path).any? do |element|
    element.attribute_value(:class) =~ /#{status}/ &&
      element.attribute_value(:'data-quantity') == quantity.to_s &&
      element.attribute_value(:'data-start-time') == start_time.to_s &&
      element.attribute_value(:'data-end-time') == end_time.to_s
  end.should be_true
end

When /^I doubleclick the requirement for the "([^\"]*)" on "([^\"]*)"$/ do |workplace, date|
  date = Date.parse(date)
  workplace = Workplace.find_by_name(workplace)

  # path = "//*[@data-day='#{date.strftime('%Y-%m-%d')}']//*[@data-workplace-id='#{workplace.id}']//*[contains(@class, 'requirement')]"
  path = "//*[@data-day='#{date.strftime('%Y-%m-%d')}']//*[@data-workplace-id]//*[contains(@class, 'requirement')]"
  elements_by_xpath(path).first.double_click
end

Then /^I should see a requirement edit form popping up$/ do
  path = "//form[contains(@class, 'edit_requirement')]"
  elements_by_xpath(path).should_not be_empty
end

Then /^I should not see a requirement at the "([^\"]*)" on "([^\"]*)"$/ do |workplace, date|
  date = Date.parse(date)
  workplace = Workplace.find_by_name(workplace)

  # path = "//*[@data-day='#{date.strftime('%Y-%m-%d')}']//*[@data-workplace-id='#{workplace.id}']//*[contains(@class, 'requirement')]"
  path = "//*[@data-day='#{date.strftime('%Y-%m-%d')}']//*[@data-workplace-id]//*[contains(@class, 'requirement')]"
  elements_by_xpath(path).should be_empty
end
