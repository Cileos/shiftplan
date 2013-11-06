Then /^no modal box should be open$/ do
  page.should have_no_css( selector_for('the modal box') )
end

Then /^I close all datepickers$/ do
  page.execute_script("$('input.stringy_date').datepicker('hide')")
  # we do not know, but sometimes the hide method does not work in the first place
  page.execute_script("$('input.stringy_date').datepicker('hide')")
  # wait a little bit so that datepicker is really closed after waiting
  sleep 0.5
end

When /^I deactivate all confirm dialogs$/ do
  page.execute_script <<-EOJS
    window.confirm = function(msg) { return true; }
  EOJS
end

Then /^I deactivate all alert dialogs$/ do
  page.execute_script <<-EOJS
    window.alert = function(msg) { return true; }
  EOJS
end

When /^I close all colorpickers$/ do
  page.execute_script("$('input.minicolors').minicolors('destroy')")
  sleep 0.5
end

When /^I disable (?:all )?jquery animations$/ do
  page.execute_script %Q~jQuery.fx.off = true~
end

When /^I leave #{capture_quoted} field$/ do |label|
  field = find_field(label)
  field[:id].should_not be_nil, "cannot leave '#{label}' field because it has no id"

  page.execute_script("$('##{field[:id]}').trigger('blur')")
end

When /^the time interval for updating the count of the notification hub elapses$/ do
  page.execute_script("$('body').trigger('tick')")
end

When /^I hover over the notification hub menu item$/ do
  page.execute_script("$('body').trigger('tack')")
end
