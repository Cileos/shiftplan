Then /^I close all datepickers$/ do
  page.execute_script("$('input.stringy_date').datepicker('hide')")
  # we do not know, but sometimes the hide method does not work in the first place
  page.execute_script("$('input.stringy_date').datepicker('hide')")
  # wait a little bit so that datepicker is really closed after waiting
  sleep 0.5
end

Then /^I deactivate all confirm dialogs$/ do
  page.execute_script <<-EOJS
    window.confirm = function(msg) { return true; }
  EOJS
end
