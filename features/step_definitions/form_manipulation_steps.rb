When /^I manipulate the form #{capture_quoted} with attribute #{capture_quoted} and value #{capture_quoted_with_empty}$/ do |form_class, attribute, value|
  page.execute_script <<-EOJS
    $('form.#{form_class}').append('<input type="hidden" name="#{attribute}" value="#{value}" />')
  EOJS
end
