Feature: Resetting Password
  As a user
  I want to reset my password

  Background:
    Given an account exists
      And an organization exists with name: "Fukushima GmbH", account: the account
      And a confirmed user exists with email: "bart@thesimpsons.com"
      And an employee exists with user: the confirmed user, account: the account
      And the employee is a member in the organization
      And a clear email queue

  Scenario: Resetting password
    Given I am on the home page
     When I follow "Einloggen"
      And I follow "Passwort vergessen"
      And I fill in "E-Mail" with "bart@thesimpsons.com"
      And I press "Passwort zurückzusetzen"
     Then I should be on the sign in page
      And I should see notice "Du wirst in ein paar Minuten eine E-Mail erhalten, um Dein Passwort zurückzusetzen."
      And "bart@thesimpsons.com" should receive an email

     When I open the email
      And I follow the first link in the email
      And I fill in "Passwort" with "topsecret"
      And I fill in "Passwort bestätigen" with "topsecret"
      And I press "Passwort ändern"
     Then I should see notice "Dein Passwort wurde erfolgreich geändert - Du bist nun angemeldet."
      And I am signed in as the confirmed user
