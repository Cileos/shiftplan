Then /^I should be signed in as "([^"]*)"$/ do |email|
  step %Q~I should see "#{email}" within "#session"~
end

Then /^I should be signed in as "([^"]*)" for #{capture_model}$/ do |email_or_name, organisation|
  step %Q~I should see "#{email_or_name}" within "#session"~
  step %Q~I should see "#{model!(organisation).name}" within "#session"~
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
  if user.employees.count == 1
    step %{I should be signed in as "#{user.employees.first.name}"}
  else
    step %{I should be signed in as "#{user.email}"}
  end
end

Given /^I am signed in$/ do
  step %{a confirmed_user "me" exists}
  step %{I am signed in as confirmed_user "me"}
end

When /^I sign in$/ do
  step %~I am signed in~
end

When /^I sign out$/ do
  with_scope 'the navigation' do
    page.first('ul#session li.dropdown a.dropdown-toggle').click
  end
  step %~I follow "Ausloggen"~
  step %~I should see "Erfolgreich ausgeloggt."~
end

When /^I sign in as #{capture_model}$/ do |model|
  step %~I am signed in as #{model}~
end

Then /^#{capture_model} should have the role "([^"]*)"$/ do |name, role|
  model!(name).roles.should include(role)
end
