Feature: Signing in
  In order to protect my data and to only see my data
  As a visitor
  I want to sign in

  Scenario: Signing in successfully
    Given I am on the home page
      And a confirmed_user exists with email: "me@example.com"
     When I follow "Einloggen"
      And I fill in "E-Mail" with "me@example.com"
      And I fill in "Passwort" with "secret"
      And I press "Einloggen"
     Then I should see "Erfolgreich eingeloggt."
      And I should be logged in as "me@example.com"
      And I should be on my dashboard
      And I should be signed in as "me@example.com"
