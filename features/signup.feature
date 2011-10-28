Feature: Signing up
  In order to use the application
  As a random visitor
  I want to sign up

  Scenario: Signup with email address
    Given I am on the home page
     When I follow "Registrieren"
      And I fill in the following:
        | E-Mail              | me@example.com |
        | Passwort            | secret         |
        | Passwort bestätigen | secret         |
      And I press "Registrieren"
     Then I should see "Du hast Dich erfolgreich registriert. Bitte schau in Dein Postfach, um Deine E-Mail-Adresse zu bestätigen."
      And "me@example.com" should receive an email

     When I open the email
      And I click the first link in the email
     Then I should see "bestätigt"
      And I should be logged in as "me@example.com"
