Feature: As a logged in user
  I want to change my password

  Background:
    Given an organization "fukushima" exists with name: "Fukushima GmbH"
      And a confirmed user exists with email: "marge@thesimpsons.com"
      And an employee exists with user: the confirmed user, organization: the organization "fukushima", first_name: "Marge", last_name: "Bouvier"
      And I am signed in as the confirmed user
      And I am on my dashboard

  Scenario: Changing the email address
    Given I choose "Einstellungen" from the drop down "Marge Bouvier"
     Then I should be on the edit page of the confirmed user
     When I fill in the following within the second form:
       | Aktuelles Passwort        | secret    |
       | Neues Passwort            | topsecret |
       | Neues Passwort bestätigen | topsecret |
      And I press "Speichern" within the second form
     Then I should be on the edit page of the confirmed user
      And I should see a flash info "Passwort geändert."

     When I sign out
      And I am on the home page
      And I follow "Einloggen"
      And I fill in "E-Mail" with "marge@thesimpsons.com"
      And I fill in "Passwort" with "topsecret"
      And I press "Einloggen"
      And I should see "Erfolgreich eingeloggt."
