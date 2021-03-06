#encoding: UTF-8

Given /^I (reinvite|invite) #{capture_model} with the email address "([^"]*)" for the organization "([^"]*)"$/ do |invite_or_reinvite, employee, email, organization|
  employee = model!(employee)
  step %{a clear email queue}
  step %{I go to the employees page for the organization "#{organization}"}
  if invite_or_reinvite == 'invite'
    step %{I follow "Einladen" within the table cell "Aktion"\/"#{employee.last_and_first_name}"}
  else
    step %{I follow "Erneut einladen" within the table cell "Aktion"\/"#{employee.last_and_first_name}"}
  end
  step %{I wait for the modal box to appear}
  if invite_or_reinvite == 'reinvite'
    step %{the "E-Mail" field should contain "#{employee.invitation.email}"}
  end
  step %{I fill in "E-Mail" with "#{email}"}
  step %{I press "Einladung verschicken"}
end

Then /^I should see that the invitation for "([^"]*)" and organization "([^"]*)" was successful$/ do |email,organization|
  step %{I wait for the modal box to disappear}
  step %{I should see flash notice "Die Einladung wurde erfolgreich verschickt."}
  step %{I should be on the employees page for the organization "#{organization}"}
  # Do not send an extra account confirmation mail, invitation mail is enough
  step %{"#{email}" should receive 1 email}
  step %{"#{email}" should receive an email with subject "Sie wurden zu Clockwork eingeladen"}
end

When /^#{capture_model} accepts the invitation for the organization "([^"]*)" (with|without) setting a password$/ do |employee_name, organization_name, with_or_without|
  employee = model!(employee_name)
  step %{I open the email with subject "Sie wurden zu Clockwork eingeladen"}
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
    step %{I should see a flash notice "Vielen Dank, dass Sie Ihre Einladung bestätigen wollen. Sie müssen lediglich noch ein Passwort festlegen, um die Einladungsbestätigung erfolgreich abzuschließen."}
    step %{I fill in "Passwort" with "secret!"}
    step %{I fill in "invitation_user_attributes_password_confirmation" with "secret!"}
    step %{I press "Passwort setzen"}
  end

  name_or_email = if employee.reload.user.multiple?
    employee.user.email
  else
    employee.name
  end
  # When there is only one organization, we will be redirected there from the dashboard
  # step %{I should be on the dashboard page}
  step %{I should be signed in as "#{name_or_email}"}
  step %{I should see "Vielen Dank, dass Sie Ihre Einladung zu Clockwork akzeptiert haben."}
end

When /^I try to accept an invitation with an invalid token$/ do
  visit '/invitation/accept?token=someinvalidtoken'
end

Then /^#{capture_model} should (be|not be) confirmed$/ do |user, be_or_not_be|
  user = model!(user)
  if be_or_not_be =~ /not/
    user.should_not be_confirmed
  elsif
    user.should be_confirmed
  end
end

