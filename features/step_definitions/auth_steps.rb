Then /^I should be signed in as "([^"]*)"$/ do |email|
  Then %Q~I should see "#{email}" within "#session"~
end

Given /^I am signed in as #{capture_model}$/ do |user|
  unless user.include?('the') || user.include?('"')
    Given %{#{user} exists}
  end
  user = model!(user)
  Given %{I am on the home page}
   When %{I follow "Einloggen"}
    And %{I fill in "E-Mail" with "#{user.email}"}
    And %{I fill in "Passwort" with "secret"}
    And %{I press "Einloggen"}
   Then %{I should see "Erfolgreich eingeloggt."}
    And %{I should be signed in as "#{user.email}"}
end

Given /^I am signed in$/ do
  Given %{a confirmed_user "me" exists}
    And %{I am signed in as confirmed_user "me"}
end

When /^I sign in$/ do
  Given %~I am signed in~
end

When /^I sign out/ do
  When %~I follow "signout"~
  Then %~I should see "Signed out successfully."~
end

When /^I sign in as #{capture_model}$/ do |model|
  Given %~I am signed in as #{model}~
end

Then /^#{capture_model} should have the role "([^"]*)"$/ do |name, role|
  model!(name).roles.include?(role).should be_true
end
