# FIXME A major part of these Scenarios should be migrated into controller specs
@javascript
Feature: Inviting Employees
  As a planner
  I want to invite my employees
  So that they can see when they have to work and can comment on plans and shifts

  Background:
    Given today is "2012-05-23 12:00"
      And mr burns, owner of the Springfield Nuclear Power Plant exists
      And I am signed in as the user "mr burns"
      And an employee "homer" exists with account: the account, first_name: "Homer"
      And a membership exists with organization: the organization, employee: the employee "homer"

  Scenario: Adding an then inviting an employee with an email address that does not exist yet (full roundtrip for adding employees and inviting them)
    Given I am on the employees page for the organization
     Then I should see the following table of employees:
        | Name            |
        | Burns, Charles  |
        | Simpson, Homer  |
     When I follow "Hinzufügen"
      And I fill in the following:
        | Vorname           | Carl    |
        | Nachname          | Carlson |
      And I press "Anlegen"
     Then I should see the following table of employees:
        | Name            |
        | Burns, Charles  |
        | Carlson, Carl   |
        | Simpson, Homer  |

    Given a clear email queue
     When I go to the employees page for the organization "sector 7g"
      And I follow "Einladen" within the table cell "Aktion"/"Carlson, Carl"
      And I wait for the modal box to appear
      And I fill in "E-Mail" with "carl@carlson.com"
      And I press "Einladung verschicken"
     Then I should see that the invitation for "carl@carlson.com" and organization "sector 7g" was successful
      And "c.burns@npp-springfield.com" should have no email
      But "carl@carlson.com" should have an email
     When I sign out

     When I open the email with subject "Sie wurden zu Clockwork eingeladen"
     When I follow "Einladung akzeptieren" in the email
     Then I should see a flash notice "Vielen Dank, dass Sie Ihre Einladung bestätigen wollen. Sie müssen lediglich noch ein Passwort festlegen, um die Einladungsbestätigung erfolgreich abzuschließen."
     When I fill in "Passwort" with "secret!"
      And I fill in "invitation_user_attributes_password_confirmation" with "secret!"
      And I press "Passwort setzen"
     Then I should see a flash notice "Vielen Dank, dass Sie Ihre Einladung zu Clockwork akzeptiert haben."
      And "c.burns@npp-springfield.com" should receive an email with subject "Carl Carlson hat ihre Einladung akzeptiert"

  Scenario: Inviting an employee with an email address that does not exist yet
     When I invite the employee "homer" with the email address "homer@thesimpsons.com" for the organization "sector 7g"
     Then I should see that the invitation for "homer@thesimpsons.com" and organization "sector 7g" was successful
     When I sign out
     And the employee "homer" accepts the invitation for the organization "sector 7g" with setting a password

  Scenario: Inviting an employee without entering an email address
    When I invite the employee "homer" with the email address "" for the organization "sector 7g"
    Then I should see "muss ausgefüllt werden"

  Scenario: Accepting the same invitation a second time
    When I invite the employee "homer" with the email address "homer@thesimpsons.com" for the organization "sector 7g"
    Then I should see that the invitation for "homer@thesimpsons.com" and organization "sector 7g" was successful
    When I sign out
     And the employee "homer" accepts the invitation for the organization "sector 7g" with setting a password

   # accept invitation again, still being logged in
   When I open the email with subject "Sie wurden zu Clockwork eingeladen"
    And I follow "Einladung akzeptieren" in the email
   Then I should see "Sie haben diese Einladung bereits akzeptiert."
    And I should not see "Bitte loggen Sie sich mit Ihrer E-Mail Adresse und Ihrem Passwort ein."

    When I sign out
    # accept invitation again, when being logged out
    When I open the email with subject "Sie wurden zu Clockwork eingeladen"
     And I follow "Einladung akzeptieren" in the email
    Then I should be on the signin page
     And I should see "Sie haben diese Einladung bereits akzeptiert."
     And I should see "Bitte loggen Sie sich mit Ihrer E-Mail Adresse und Ihrem Passwort ein."

  Scenario: Accepting an invitation with an invalid invitation token
    When I try to accept an invitation with an invalid token
    Then I should see "Der Einladungstoken ist nicht gültig. Ihre Einladung konnte nicht akzeptiert werden."

  Scenario: Accepting an invitation by providing an invalid password confirmation
    When I invite the employee "homer" with the email address "homer@thesimpsons.com" for the organization "sector 7g"
    Then I should see that the invitation for "homer@thesimpsons.com" and organization "sector 7g" was successful
    When I sign out

    When I open the email with subject "Sie wurden zu Clockwork eingeladen"
     And I follow "Einladung akzeptieren" in the email
     And I fill in "Passwort" with "secret!"
     And I fill in "invitation_user_attributes_password_confirmation" with "wrong confirmation"
     And I press "Passwort setzen"
    Then I should see "stimmt nicht mit der Bestätigung überein"

    When I fill in "Passwort" with "secret!"
    When I fill in "invitation_user_attributes_password_confirmation" with "secret!"
     And I press "Passwort setzen"
    Then I should be signed in as "Homer Simpson"
     And I should see "Vielen Dank, dass Sie Ihre Einladung zu Clockwork akzeptiert haben."

  Scenario: Inviting with an email that's already assigned to an employee of a different account
    Given an account "tschernobyl" exists with name: "Tschernobyl GmbH"
      And an organization "überwachungszentrale" exists with name: "Überwachungszentrale"
      And a confirmed user "homer 2" exists with email: "homer@thesimpsons.com"
      And an employee "homer 2" exists with user: the confirmed user "homer 2", account: the account "tschernobyl"
      And a membership exists with organization: the organization "überwachungszentrale", employee: the employee "homer 2"

     When I invite the employee "homer" with the email address "homer@thesimpsons.com" for the organization "sector 7g"
     Then I should see that the invitation for "homer@thesimpsons.com" and organization "sector 7g" was successful
     When I sign out
      And the employee "homer" accepts the invitation for the organization "sector 7g" without setting a password

  Scenario: Inviting an employee with an email address of an unconfirmed user which has not been invited yet
    Given an account "tschernobyl" exists with name: "Tschernobyl GmbH"
      And an organization "überwachungszentrale" exists with name: "Überwachungszentrale"
      And a user "homer 2" exists with email: "homer@thesimpsons.com"
      And an employee "homer 2" exists with user: the user "homer 2", account: the account "tschernobyl"
      And a membership exists with organization: the organization "überwachungszentrale", employee: the employee "homer 2"
     Then the user "homer 2" should not be confirmed

     When I invite the employee "homer" with the email address "homer@thesimpsons.com" for the organization "sector 7g"
     Then I should see that the invitation for "homer@thesimpsons.com" and organization "sector 7g" was successful
     When I sign out
      And the employee "homer" accepts the invitation for the organization "sector 7g" with setting a password
     Then the user "homer 2" should be confirmed

  Scenario: Reinviting an employee which has not accepted the invitation yet
    When I invite the employee "homer" with the email address "homer@thesimpsons.com" for the organization "sector 7g"
    Then I should see that the invitation for "homer@thesimpsons.com" and organization "sector 7g" was successful

    When I reinvite the employee "homer" with the email address "homer@thesimpsons.com" for the organization "sector 7g"
    Then I should see that the invitation for "homer@thesimpsons.com" and organization "sector 7g" was successful
    When I sign out
    And the employee "homer" accepts the invitation for the organization "sector 7g" with setting a password

  Scenario: Displaying the e-mail address or the invitation status on the employees page
    When I go to the employees page for the organization "sector 7g"
    Then I should see the following table of employees:
      | Name            | E-Mail                       | Status                 |
      | Burns, Charles  | c.burns@npp-springfield.com  | Aktiv                  |
      | Simpson, Homer  |                              | Noch nicht eingeladen  |

    When I invite the employee "homer" with the email address "homer@thesimpsons.com" for the organization "sector 7g"
    Then I should see that the invitation for "homer@thesimpsons.com" and organization "sector 7g" was successful
    Then I should see the following table of employees:
      | Name            | E-Mail                       | Status                                 |
      | Burns, Charles  | c.burns@npp-springfield.com  | Aktiv                                  |
      | Simpson, Homer  | homer@thesimpsons.com        | Eingeladen am 23.05.2012 um 12:00 Uhr  |

    Given today is "2012-05-24 12:00"
    # need to sign in again because the session has expired
    And I am signed in as the user "mr burns"
    When I reinvite the employee "homer" with the email address "homer@thesimpsons.com" for the organization "sector 7g"
    Then I should see that the invitation for "homer@thesimpsons.com" and organization "sector 7g" was successful
    Then I should see the following table of employees:
      | Name            | E-Mail                       | Status                                 |
      | Burns, Charles  | c.burns@npp-springfield.com  | Aktiv                                  |
      | Simpson, Homer  | homer@thesimpsons.com        | Eingeladen am 24.05.2012 um 12:00 Uhr  |
    And I sign out

    When the employee accepts the invitation for the organization "sector 7g" with setting a password
    And I sign out

    And I am signed in as the user "mr burns"
    When I go to the employees page for the organization "sector 7g"
    Then I should see the following table of employees:
      | Name            | E-Mail                 | Status  |
      | Burns, Charles  | c.burns@npp-springfield.com  | Aktiv  |
      | Simpson, Homer  | homer@thesimpsons.com        | Aktiv  |

  Scenario: Inviting with an email that's already assigned to an employee of the same organization
   Given an employee "bart" exists with account: the account, first_name: "Bart"
     And a membership exists with organization: the organization, employee: the employee "bart"
    When I invite the employee "homer" with the email address "homer@thesimpsons.com" for the organization "sector 7g"
    Then I should see that the invitation for "homer@thesimpsons.com" and organization "sector 7g" was successful

    When I invite the employee "bart" with the email address "homer@thesimpsons.com" for the organization "sector 7g"
    Then I should see "ist bereits vergeben"
     And "homer@thesimpsons.com" should receive no email

    When I invite the employee "bart" with the email address "bart@thesimpsons.com" for the organization "sector 7g"
    Then I should see that the invitation for "bart@thesimpsons.com" and organization "sector 7g" was successful

