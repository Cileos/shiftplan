Feature: Signing up
  In order to use the application
  As a random visitor
  I want to sign up
  And I want to become the owner of my account

  Scenario: Signup by filling in information for all signup fields
    Given I am on the home page
      And 0 accounts should exist
      And 0 organizations should exist
      And 0 blogs should exist
      And 0 users should exist
      And 0 employees should exist
      And 0 memberships should exist
     When I follow "Registrieren"
     Then I should see "Veridian Dynamics" within a hint
      And I fill in the following:
        | Accountbezeichnung  | Fukushima GmbH |
        | Organisationsname   | Reaktor A      |
        | Vorname             | Homer          |
        | Nachname            | Simpson        |
        | E-Mail              | me@example.com |
        | Passwort            | secret         |
        | Passwort bestätigen | secret         |
      And I press "Registrieren"
     Then I should see "Du hast Dich erfolgreich registriert. Bitte schau in Dein Postfach, um Deine E-Mail-Adresse zu bestätigen."
      And "me@example.com" should receive an email

      # auto-creation of account, organization, employee and blog
      And an account should exist with name: "Fukushima GmbH"
      And an organization should exist with name: "Reaktor A", account: the account
      And a blog should exist with organization: the organization
      And a user should exist with email: "me@example.com"
      And an employee should exist with role: "owner", account: the account, first_name: "Homer", last_name: "Simpson", user: the user
      # Employees can only be scheduled in organizations for which they have a
      # membership. The account owner, the employee with role "owner", is
      # mostly the person who just pays the bills. So we do not create a
      # membership for him for the first organization on signup.  If the owner
      # should be scheduled within organizations, he can be added later on the
      # employees page of the organization.
      And 0 memberships should exist

     When I open the email
      And I click the first link in the email
     Then I should see "bestätigt"
      And I should be signed in as "Homer Simpson"
      And I should be on the dashboard page
      And I should see "Fukushima GmbH"
     When I follow "Reaktor A"
     Then I should be on the page of the organization


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

