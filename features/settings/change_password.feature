Feature: As a logged in user
  I want to change my password

  Background:
    Given mr burns, owner of the Springfield Nuclear Power Plant exists
      And I am signed in as the user "mr burns"
      And I am on my dashboard

  Scenario: Changing the password
    Given I choose "Einstellungen" from the session and settings menu item
      And I follow "Passwort ändern"
     Then I should be on the change password page
     When I fill in the following:
       | Aktuelles Passwort        | secret    |
       | Neues Passwort            | topsecret |
       | Neues Passwort bestätigen | topsecret |
      And I press "Speichern"
     Then I should be on the change password page
      And I should see a flash notice "Passwort geändert."

     When I sign out
      And I am on the home page
      And I follow "Einloggen"
      And I fill in "E-Mail" with "c.burns@npp-springfield.com"
      And I fill in "Passwort" with "topsecret"
      And I press "Einloggen"
      And I should see "Erfolgreich eingeloggt."

  Scenario: Trying to change the password with providing a wrong current password
    Given I am on the change password page
     When I fill in the following:
       | Aktuelles Passwort        | wrongpass |
       | Neues Passwort            | topsecret |
       | Neues Passwort bestätigen | topsecret |
      And I press "Speichern"
     Then I should be on the change password page
      And I should see a flash alert "Ihr Passwort konnte nicht geändert werden."
      And I should see "ist nicht gültig"

  Scenario: Trying to change the password with providing a wrong password confirmation
    Given I am on the change password page
     When I fill in the following:
       | Aktuelles Passwort        | secret      |
       | Neues Passwort            | topsecret   |
       | Neues Passwort bestätigen | wrongpwconf |
      And I press "Speichern"
     Then I should be on the change password page
      And I should see a flash alert "Ihr Passwort konnte nicht geändert werden."
      And I should see "stimmt nicht mit der Bestätigung überein"
