Feature: Signing up
  In order to use the application
  As a random visitor
  I want to sign up
  And I want to become the owner of my first organization
  And the organization should be automatically created
  Because I do not want to deal with the concept of organizations yet

  Scenario: Signup by filling in information for all signup fields
    Given I am on the home page
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

      # auto-creation of organization, employee and blog
      And an organization should exist with name: "Fukushima GmbH"
      And a user should exist with email: "me@example.com"
      And an employee should exist with role: "owner", first_name: "Homer", last_name: "Simpson", user: the user, organization: the organization
      And a blog should exist with organization: the organization

     When I open the email
      And I click the first link in the email
     Then I should see "bestätigt"
      And I should be signed in as "me@example.com"

