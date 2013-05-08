# For a user with multiple account the email address will be shown in the user navigation
# when being logged in.
# On the other hand a user with just one account can only have one employee. So we show
# the employee's name in the user navigation in this case.
Then /^I should be signed in as "([^"]*)"$/ do |email_or_name|
  step %Q~I should see "#{email_or_name}" within the orientation bar~
end

Then /^I should be signed in as "([^"]*)" for #{capture_model}$/ do |email_or_name, organisation|
  step %Q~I should see "#{email_or_name}" within the orientation bar~
  step %Q~I should see "#{model!(organisation).name}" within the navigation~
end

Given /^I am signed in as #{capture_model}$/ do |user|
  unless user.include?('the') || user.include?('"')
    step %{#{user} exists}
  end
  user = model!(user)
  visit fast_sign_in_path(email: user.email)
  page.should have_content('success')
end

Given /^I am signed in$/ do
  step %{a confirmed_user "me" exists}
  step %{I am signed in as confirmed_user "me"}
end

When /^I sign in$/ do
  step %~I am signed in~
end

Given /^I am signed out$/ do
  step 'I sign out'
end

When /^I sign out$/ do
  step %~I choose "Ausloggen" from the user navigation~
  step %~I should see "Erfolgreich ausgeloggt."~
end

When /^I sign in as #{capture_model}$/ do |model|
  step %~I am signed in as #{model}~
end

Then /^#{capture_model} should have the role "([^"]*)"$/ do |name, role|
  model!(name).roles.should include(role)
end

Given /^the account of #{capture_model} has been locked$/ do |user|
  model!(user).lock_access!
end

When /^I sign in with #{capture_quoted} (?:and )?#{capture_quoted}$/ do |email, password|
  fill_in 'user_email', with: email
  fill_in 'user_password', with: password
  first('input[name=commit]').click
end
