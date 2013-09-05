Feature: Signing up
  In order to use the application
  As a random visitor
  I want to sign up
  And I want to become the owner of my account

  Scenario: Signup by filling in information for all signup fields
    Given I use a german browser
      And I am on the home page
      And 0 accounts should exist
      And 0 organizations should exist
      And 0 blogs should exist
      And 0 users should exist
      And 0 employees should exist
      And 0 memberships should exist
     When I follow "Registrieren"
     Then I should see "Veridian Dynamics (muss mit Buchstaben beginnen)" within a hint
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

      # auto-creation of account, organization, employee, membership and blog
      And an account "fukushima" should exist with name: "Fukushima GmbH"
      And an organization "reaktor" should exist with name: "Reaktor A", account: the account
      And a blog should exist with organization: the organization
      And a user should exist with email: "me@example.com"
      And an employee "owner" should exist with account: the account, first_name: "Homer", last_name: "Simpson", user: the user
      And a membership should exist with employee: the employee "owner", organization: the organization "reaktor"
      Then the employee "owner" should be account "fukushima"'s owner

     When I open the email
      And I click the first link in the email
     Then I should see "bestätigt"
      And I should be signed in as "Homer Simpson"
      And I should be on the page of the organization
     When I follow "Alle Organisationen"
     # Check if the registered user is really an owner:
     # - only owners can edit accounts
     Then I should see link "Account bearbeiten"
     # - only owners can create organizations
      And I should see link "Organisation hinzufügen"


  @javascript
  Scenario: Show mail address suggestion if typo in email address
    Given I am on the signup page
      And I fill in the following:
        | E-mail              | bart.simpson@yaho.com |
        | Password            | secret                |
     Then I should see "Did you mean bart.simpson@yahoo.com?"

     When I follow "bart.simpson@yahoo.com"
     Then the "E-mail" field should contain "bart.simpson@yahoo.com"
      And I should not see "Did you mean Sie bart.simpson@yahoo.com?"

  @javascript
  Scenario: New mail address suggestion clears previous suggestion
    Given I am on the signup page
      And I fill in the following:
        | E-mail              | bart.simpson@yaho.com |
        | Password            | secret                |
     Then I should see "Did you mean bart.simpson@yahoo.com?"

     When I fill in the following:
        | E-mail              | bart.simpson@gnail.com |
        | Password            | secret                 |
     Then I should not see "Did you mean bart.simpson@yahoo.com?"
      But I should see "Did you mean bart.simpson@gmail.com?"

