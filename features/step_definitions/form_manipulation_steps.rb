When /^I manipulate the form "(.*?)" with attribute "(.*?)" and value "(.*?)"$/ do |form_id, attribute, value|
  page.execute_script <<-EOJS
    $('form.#{form_id}').append('<input type="hidden" name="#{attribute}" value="#{value}" />')
  EOJS
end
