Feature: Signing in
  In order to protect my data and to only see my data
  As a visitor
  I want to sign in

  Scenario: Signing in and signing out successfully
    Given I am on the home page
      And a confirmed user exists with email: "me@example.com"
      And an employee planner exists with user: the confirmed user, first_name: "Bart", last_name: "Simpson"
     When I follow "Einloggen"
      And I fill in "E-Mail" with "me@example.com"
      And I fill in "Passwort" with "secret"
      And I press "Einloggen"
     Then I should see "Erfolgreich eingeloggt."
      And I should be on my dashboard
      And I should be signed in as "Bart Simpson"
     When I follow "Ausloggen"
     Then I should be on the home page
      And I should see "Einloggen"
