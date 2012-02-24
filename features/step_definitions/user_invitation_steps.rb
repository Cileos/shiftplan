Given /^I (reinvite|invite) #{capture_model} with the email address "([^"]*)"$/ do |invite_or_reinvite, employee, email|
  step %{I go to the employees page}
  step %{I follow "#{model!(employee).first_name}"}
  step %{I follow "Bearbeiten"}
  if invite_or_reinvite == 'invite'
    step %{I should not see "Sie haben den Mitarbeiter noch nicht eingeladen"}
    step %{I follow "Mitarbeiter einladen"}
  else
    step %{a clear email queue}
    step %{I should see "Sie haben diesen Mitarbeiter am 01. Januar, 12:00 Uhr eingeladen."}
    step %{I should see "Die Einladung wurde noch nicht akzeptiert."}
    step %{I follow "Mitarbeiter erneut einladen"}
  end
  step %{I fill in "E-Mail" with "#{email}"}
  step %{I press "Einladung verschicken"}
  step %{I should see flash notice "Die Einladung wurde erfolgreich verschickt."}
  step %{I should be on the edit page for the employee}
  # Do not send an extra account confirmation mail, invitation mail is enough
  step %{"#{email}" should receive 1 email}
  step %{"#{email}" should receive an email with subject "Sie wurden zu Shiftplan eingeladen"}
end

When /^#{capture_model} accepts the invitation (with|without) setting a password$/ do |employee, with_or_without|
  step %{I open the email with subject "Sie wurden zu Shiftplan eingeladen"}
  if with_or_without == 'with'
    step %{I should see "Ihr Account wird nicht angelegt solange Sie nicht" in the email body}
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
end
