# encoding: utf-8
#
# Assuming we just clicked on a scheduling in one of the views, a modal box should open..
Then /^I (?:should be able to change|change) the #{capture_quoted} from #{capture_quoted} to #{capture_quoted} and select #{capture_quoted} as #{capture_quoted}$/ do |quickie_field, old_quickie, quickie, employee, employee_field|
  within_modal_box do
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
end

# I fill in the empty "Quickie" with "9-17" and select "Homer S" as "Mitarbeiter"
When /^I fill in the empty #{capture_quoted} with #{capture_quoted} and select #{capture_quoted} as #{capture_quoted}$/ do |quickie_field, quickie, employee, employee_field|
  within_modal_box do
    find_field(quickie_field).value.should be_empty

    fill_in quickie_field, with: '1-'
    click_button "Anlegen"
    with_scope 'errors' do
      page.should have_content("#{quickie_field} ist nicht gültig")
    end

    fill_in quickie_field, with: quickie
    select employee, from: employee_field
    click_button "Anlegen"
  end
end

# TODO same as "I fill in the empty" ?
When /^I schedule #{capture_quoted} on #{capture_quoted} for #{capture_quoted}$/ do |employee, day, quickie|
  step %Q~I click on cell "#{day}"/"#{employee}"~
  within_modal_box do
    fill_in 'Quickie', with: quickie
    click_button "Anlegen"
  end
end


When /^I comment #{capture_quoted}$/ do |comment|
  field = "Kommentar"
  within_modal_box do
    find_field(field).text.should be_empty
    fill_in field, with: comment
    click_button 'Kommentieren'
    step %Q~I wait for the spinner to disappear~
    # model box auto-closes since eecfa7cca96872cfc9
    #find_field(field).text.should be_empty
    #with_scope 'comments' do
    #  all('div.own-meta').map(&:text).join(' ').should =~ /Sie haben am #{match_date_with_time} geschrieben:/
    #end
  end
end


module ModalBoxHelper
  def within_appearing(name, close=false)
    step %Q~I wait for #{name} to appear~
    with_scope name do
      yield
    end
    if close
      step %Q~I close #{name}~
    end
    step %Q~I wait for #{name} to disappear~

  end
  def within_modal_box(close=false, &block)
    within_appearing 'the modal box', close, &block
  end
end

World(ModalBoxHelper)
