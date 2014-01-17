# encoding: utf-8
#

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

When /^I pick "(\d{1,2})\.\s*([a-zA-Z]+)\s+(\d{4})" from "(.*?)"$/ do |day, month, year, label|
  step %Q~I disable all jquery animations~
  step %Q~I click on the "#{label}" label~
  step %Q~I select "#{year}" from "anderes Jahr anzeigen" within the datepicker~
  step %Q~I select "#{month}" from "anderen Monat anzeigen" within the datepicker~
  step %Q~I follow "#{day}" within the datepicker~
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
