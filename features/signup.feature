Feature: Signing up
  In order to use the application
  As a random visitor
  I want to sign up
  And I want to become the owner of my first organization
  And the organization should be automatically created
  Because I do not want to deal with the concept of organizations yet

  Scenario: Signup with email address
    Given I am on the home page
      And 0 organizations should exist
     When I follow "Registrieren"
      And I fill in the following:
        | E-Mail              | me@example.com |
        | Passwort            | secret         |
        | Passwort bestätigen | secret         |
      And I press "Registrieren"
     Then I should see "Du hast Dich erfolgreich registriert. Bitte schau in Dein Postfach, um Deine E-Mail-Adresse zu bestätigen."
      And "me@example.com" should receive an email
      And a user should exist with email: "me@example.com"

      # auto-creation of organization and own employee with role "owner"
      And an employee should exist
      And the employee's role should be "owner"
      And the user should be the employee's user
      And an organization should exist
      And the organization should be in the user's organizations
      And the organization should be the employee's organization

     When I open the email
      And I click the first link in the email
     Then I should see "bestätigt"
      And I should be signed in as "me@example.com"

