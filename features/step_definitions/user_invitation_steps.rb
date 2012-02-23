Given /^I invite #{capture_model} with the email address "([^"]*)"$/ do |employee, email|
  step %{I follow "Mitarbeiter"}
  step %{I follow "#{model!(employee).first_name}"}
  step %{I follow "Bearbeiten"}
  step %{I follow "Mitarbeiter einladen"}
  step %{I fill in "E-Mail" with "#{email}"}
  step %{I press "Einladung verschicken"}
  step %{I should see flash notice "Die Einladung wurde erfolgreich verschickt."}
  step %{I should be on the edit page for the employee}
  step %{"#{email}" should receive an email with subject "Sie wurden zu Shiftplan eingeladen"}
end

