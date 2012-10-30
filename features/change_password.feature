Feature: As a logged in user
  I want to change my password

  Background:
    Given an account exists with name: "Tepco GmbH"
      And an organization "fukushima" exists with name: "Fukushima", account: the account
      And a confirmed user exists with email: "marge@thesimpsons.com"
      And an employee exists with user: the confirmed user, account: the account, first_name: "Marge", last_name: "Bouvier"
      And a membership exists with organization: the organization, employee: the employee
      And I am signed in as the confirmed user
      And I am on my dashboard

  Scenario: Changing the password
    Given I choose "Einstellungen" from the drop down "Marge Bouvier"
      And I follow "Passwort ändern"
     Then I should be on the password page of the confirmed user
     When I fill in the following:
       | Aktuelles Passwort        | secret    |
       | Neues Passwort            | topsecret |
       | Neues Passwort bestätigen | topsecret |
      And I press "Speichern"
     Then I should be on the password page of the confirmed user
      And I should see a flash info "Passwort geändert."

     When I sign out
      And I am on the home page
      And I follow "Einloggen"
      And I fill in "E-Mail" with "marge@thesimpsons.com"
      And I fill in "Passwort" with "topsecret"
      And I press "Einloggen"
      And I should see "Erfolgreich eingeloggt."

  Scenario: Trying to change the password with providing a wrong current password
    Given I am on the password page of the confirmed user
     When I fill in the following:
       | Aktuelles Passwort        | wrongpass |
       | Neues Passwort            | topsecret |
       | Neues Passwort bestätigen | topsecret |
      And I press "Speichern"
     Then I should be on the password page of the confirmed user
      And I should see a flash alert "Ihr Passwort konnte nicht geändert werden."
      And I should see "ist nicht gültig"

  Scenario: Trying to change the password with providing a wrong password confirmation
    Given I am on the password page of the confirmed user
     When I fill in the following:
       | Aktuelles Passwort        | secret      |
       | Neues Passwort            | topsecret   |
       | Neues Passwort bestätigen | wrongpwconf |
      And I press "Speichern"
     Then I should be on the password page of the confirmed user
      And I should see a flash alert "Ihr Passwort konnte nicht geändert werden."
      And I should see "stimmt nicht mit der Bestätigung überein"
