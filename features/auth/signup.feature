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
     Then I should see "Du hast Dich erfolgreich registriert. Wir konnten Dich noch nicht anmelden, da Dein Account noch nicht bestätigt ist. Du erhältst in Kürze eine E-Mail mit der Anleitung, wie Du Deinen Account freischalten kannst"
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
     Then I should see flash notice "Vielen Dank für Deine Registrierung. Bitte melde dich jetzt an."
     When I sign in as the user
      And I go to the page of the organization
     Then I should be signed in as "Homer Simpson"
     When I follow "Alle Organisationen"
     # Check if the registered user is really an owner:
     # - only owners can edit accounts
     Then I should see link "Account bearbeiten"
     # - only owners can create organizations
      And I should see link "Organisation hinzufügen"

  Scenario: Signup by filling in malformed information
    Given I use a german browser
      And I am on the signup page
     When I fill in the following:
        | Accountbezeichnung  | Enemy #1   |
        | Organisationsname   | 50¢        |
        | Vorname             | ....       |
        | Nachname            | (((((      |
        | E-Mail              | won't tell |
        | Passwort            | secret     |
        | Passwort bestätigen | secret     |
      And I press "Registrieren"
     Then I should not see "erfolgreich"
      And I should see the following validation errors:
        | Accountbezeichnung | ist nicht gültig |
        | Organisationsname  | ist nicht gültig |
        | Vorname            | ist nicht gültig |
        | Nachname           | ist nicht gültig |
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
