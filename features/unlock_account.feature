Feature: Unlocking account
  As a user
  I want to unlock my account
  In order to regain access to my account

  Background:
    Given an account exists
      And an organization exists with name: "Fukushima GmbH", account: the account
      And a confirmed user exists with email: "bart@thesimpsons.com"
      And an employee exists with first_name: "Bart", user: the confirmed user, account: the account
      And the employee is a member in the organization
      And a clear email queue
      And the account of the confirmed user has been locked
     Then "bart@thesimpsons.com" should receive an email with subject "Account entsperren"

  Scenario: Unlock account
    Given I open the email
      And I follow the first link in the email
     Then I should see notice "Ihr Konto wurde erfolgreich entsperrt. Bitten loggen Sie sich nun ein."
      And I should see notice "Falls Sie Ihr Passwort vergessen haben, klicken Sie bitte auf 'Passwort vergessen?'"
     When I fill in "E-Mail" with "bart@thesimpsons.com"
      And I fill in "Passwort" with "secret"
      And I press "Einloggen"
     Then I should be signed in as "Bart Simpson"
