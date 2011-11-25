Then /^I should be signed in as "([^"]*)"$/ do |email|
  step %Q~I should see "#{email}" within "#session"~
end

Given /^I am signed in as #{capture_model}$/ do |user|
  unless user.include?('the') || user.include?('"')
    step %{#{user} exists}
  end
  user = model!(user)
  step %{I am on the home page}
  step %{I follow "Einloggen"}
  step %{I fill in "E-Mail" with "#{user.email}"}
  step %{I fill in "Passwort" with "secret"}
  step %{I press "Einloggen"}
  step %{I should see "Erfolgreich eingeloggt."}
  step %{I should be signed in as "#{user.email}"}
end

Given /^I am signed in$/ do
  step %{a confirmed_user "me" exists}
  step %{I am signed in as confirmed_user "me"}
end

When /^I sign in$/ do
  step %~I am signed in~
end

When /^I sign out/ do
  step %~I follow "signout"~
  step %~I should see "Signed out successfully."~
end

When /^I sign in as #{capture_model}$/ do |model|
  step %~I am signed in as #{model}~
end

Then /^#{capture_model} should have the role "([^"]*)"$/ do |name, role|
  model!(name).roles.include?(role).should be_true
end
