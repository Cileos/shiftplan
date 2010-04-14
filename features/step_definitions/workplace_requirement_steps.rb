When /^I click on the button to add an? "([^\"]*)"(?: (\d+) times)?$/ do |qualification_name, quantity|
  qualification = Qualification.find_by_name(qualification_name)
  quantity ||= 1
  quantity.to_i.times do
    within("#workplace_requirements_#{qualification.id}") { click_on(:class => 'staff_requirement new') }
  end
end

When /^I click on the button to remove an? "([^\"]*)"(?: (\d+) times)?$/ do |qualification_name, quantity|
  qualification = Qualification.find_by_name(qualification_name)
  quantity ||= 1
  quantity.to_i.times do
    within("#workplace_requirements_#{qualification.id}") { click_on(:class => 'staff_requirement delete') }
  end
end

Then /^the workplace named "([^\"]*)" should have to following workplace requirements:$/ do |workplace_name, requirements|
  workplace = Workplace.find_by_name(workplace_name)
  requirements.hashes.each do |attributes|
    qualification = Qualification.find_by_name(attributes.delete('qualification'))
    quantity      = attributes.delete('quantity').to_i
    workplace.workplace_requirements.find_by_qualification_id_and_quantity(qualification.id, quantity).should_not be_nil
  end
end
