Feature: Signing up
  In order to use the application
  As a random visitor
  I want to sign up
  And I want to become the owner of my first organization
  And the organization should be automatically created
  Because I do not want to deal with the concept of organizations yet

  Scenario: Signup by filling in information for all signup fields
    Given I am on the home page
      And 0 accounts should exist
      And 0 organizations should exist
      And 0 blogs should exist
     When I follow "Registrieren"
      And I fill in the following:
        | Organisationsname   | Fukushima GmbH |
        | Vorname             | Homer          |
        | Nachname            | Simpson        |
        | E-Mail              | me@example.com |
        | Passwort            | secret         |
        | Passwort bestätigen | secret         |
      And I press "Registrieren"
     Then I should see "Du hast Dich erfolgreich registriert. Bitte schau in Dein Postfach, um Deine E-Mail-Adresse zu bestätigen."
      And "me@example.com" should receive an email


     When I open the email
      And I click the first link in the email
     Then I should see "bestätigt"
      And I should be signed in as "Homer Simpson"

      # auto-creation of account, organization, employee and blog
      And a user should exist with email: "me@example.com"
      And an account should exist with owner: the user
      And an organization should exist with name: "Fukushima GmbH", account: the account
      And an employee should exist with role: "owner", first_name: "Homer", last_name: "Simpson", user: the user, organization: the organization
      And a blog should exist with organization: the organization

  @javascript
  Scenario: Show mail address suggestion if typo in email address
    Given I am on the signup page
      And I fill in the following:
        | E-Mail              | bart.simpson@yaho.com |
        | Passwort            | secret                |
     Then I should see "Meinten Sie bart.simpson@yahoo.com?"

     When I follow "bart.simpson@yahoo.com"
     Then the "E-Mail" field should contain "bart.simpson@yahoo.com"
      And I should not see "Meinten Sie bart.simpson@yahoo.com?"

  @javascript
  Scenario: New mail address suggestion clears previous suggestion
    Given I am on the signup page
      And I fill in the following:
        | E-Mail              | bart.simpson@yaho.com |
        | Passwort            | secret                |
     Then I should see "Meinten Sie bart.simpson@yahoo.com?"

     When I fill in the following:
        | E-Mail              | bart.simpson@gnail.com |
        | Passwort            | secret                 |
     Then I should not see "Meinten Sie bart.simpson@yahoo.com?"
      But I should see "Meinten Sie bart.simpson@gmail.com?"

