# encoding: utf-8
#
# Assuming we just clicked on a scheduling in one of the views, a modal box should open..
Then /^I should be able to change the #{capture_quoted} from #{capture_quoted} to #{capture_quoted} and select #{capture_quoted} as #{capture_quoted}$/ do |quickie_field, old_quickie, quickie, employee, employee_field|
  step %Q~I wait for the modal box to appear~
  with_scope 'the modal box' do
    find_field(quickie_field).value.should == old_quickie
    fill_in quickie_field, with: '1-'
    click_button "Speichern"
    with_scope 'errors' do
      page.should have_content("#{quickie_field} ist nicht gültig")
    end
    fill_in quickie_field, with: quickie
    select employee, from: employee_field
    click_button "Speichern"
  end
  step %Q~I wait for the modal box to disappear~
end

