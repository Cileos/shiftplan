Given /^I (reinvite|invite) #{capture_model} with the email address "([^"]*)"$/ do |invite_or_reinvite, employee, email|
  employee = model!(employee)
  step %{a clear email queue}
  step %{I go to the employees page}
  if invite_or_reinvite == 'invite'
    step %{I follow "Einladen"}
  else
    step %{I follow "Erneut einladen"}
  end
  step %{I wait for the modal box to appear}
  if invite_or_reinvite == 'reinvite'
    step %{the "E-Mail" field should contain "#{employee.user.email}"}
  end
  step %{I fill in "E-Mail" with "#{email}"}
  step %{I press "Einladung verschicken"}
  step %{I should see flash notice "Die Einladung wurde erfolgreich verschickt."}
  step %{I should be on the employees page}
  # Do not send an extra account confirmation mail, invitation mail is enough
  step %{"#{email}" should receive 1 email}
  step %{"#{email}" should receive an email with subject "Sie wurden zu Shiftplan eingeladen"}
end

When /^#{capture_model} accepts the invitation (with|without) setting a password$/ do |employee, with_or_without|
  employee = model!(employee)
  step %{I open the email with subject "Sie wurden zu Shiftplan eingeladen"}
  if with_or_without == 'with'
    step %{I should see "Ihr Account wird nicht angelegt, solange Sie nicht" in the email body}
    step %{I should see "und Ihr Passwort gesetzt haben" in the email body}
  else
    # Email should not include account and password instructions as account already exists and
    # password is already set.
    step %{I should not see "Ihr Account wird nicht angelegt solange Sie nicht" in the email body}
    step %{I should not see "und Ihr Passwort gesetzt haben" in the email body}
  end
  step %{I follow "Einladung akzeptieren" in the email}
  if with_or_without == 'with'
    step %{I fill in "Passwort" with "secret!"}
    step %{I fill in "user_password_confirmation" with "secret!"}
    step %{I press "Passwort setzen"}
  end

  step %{I should be signed in as "#{employee.user.email}" for the organization}
  step %{I should see "Vielen Dank, dass Sie Ihre Einladung zu Shiftplan akzeptiert haben."}
  step %{I should be on the dashboard page}
end
