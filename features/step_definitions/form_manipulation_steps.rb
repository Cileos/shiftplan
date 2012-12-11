When /^I manipulate the form "(.*?)" with attribute "(.*?)" and value "(.*?)"$/ do |form_class, attribute, value|
  page.execute_script <<-EOJS
    $('form.#{form_class}').append('<input type="hidden" name="#{attribute}" value="#{value}" />')
  EOJS
end
