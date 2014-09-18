Feature: Signing up
  In order to use the application
  As a random visitor
  I want to sign up
  And I want to become the owner of my account

  Scenario: Signup by filling in email and password, will continue with setup
    Given I use a german browser
      And I am on the home page
     When I follow "Registrieren"
      And I fill in the following:
        | E-Mail              | me@example.com |
        | Passwort            | secret         |
        | Passwort bestätigen | secret         |
      And I press "Registrieren"
     Then I should see "Du hast Dich erfolgreich registriert. Wir konnten Dich noch nicht anmelden, da Dein Account noch nicht bestätigt ist. Du erhältst in Kürze eine E-Mail mit der Anleitung, wie Du Deinen Account freischalten kannst"
      And a user should exist
      And "me@example.com" should receive an email

     When I open the email
      And I click the first link in the email
     Then I should see flash notice "Vielen Dank für Deine Registrierung. Bitte melde dich jetzt an."
     When I sign in as the user
      And I go to the dashboard
     Then I should be on the setup page

    # following the link again gives an expressive error message
     When I sign out
      And I open the email
      And I click the first link in the email
     Then I should see flash alert "Deine Emailadresse ist bereits bestätigt oder der Bestätigungslink ist ungültig."
      And I should see "Bestätigung erneut verschicken"
      # stupid simple form default error message
      But I should not see "Es gab einen Fehler. Weitere Details sehen Sie weiter unten."

  Scenario: Signup by filling in malformed information
    Given I use a german browser
      And I am on the signup page
     When I fill in the following:
        | E-Mail              | won't tell |
        | Passwort            | secret     |
        | Passwort bestätigen | secret     |
      And I press "Registrieren"
     Then I should not see "erfolgreich"
      And I should see the following validation errors:
        | E-Mail             | ist nicht gültig |
        | Password           |                  |


  @javascript
  Scenario: Show mail address suggestion if typo in email address
    Given I am on the signup page
      And I fill in the following:
        | E-Mail              | bart.simpson@yaho.com |
        | Passwort            | secret                |
        # Trigger blur event explicitly, cause it seens that the browser running
        # kopflos on CI behaves differently.
      And I leave the "E-Mail" field
      And I wait a bit
     Then I should see "Meinten Sie bart.simpson@yahoo.com?"

     When I follow "bart.simpson@yahoo.com"
     Then the "E-Mail" field should contain "bart.simpson@yahoo.com"
      And I should not see "Meinten Sie bart.simpson@yahoo.com?"
