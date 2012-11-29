@javascript
Feature: Inviting Employees
  As a planner
  I want to invite my employees
  So that they can see when they have to work and can comment on plans and shifts

  Background:
    Given today is "2012-05-23 12:00"
      And the situation of a just registered user
      And an employee "homer" exists with account: the account, first_name: "Homer"
      And a membership exists with organization: the organization, employee: the employee "homer"
      And I sign in as the confirmed user

  Scenario: Adding an then inviting an employee with an email address that does not exist yet (full roundtrip for adding employees and inviting them)
    Given I am on the employees page for the organization
    Then I should see the following table of employees:
      | Name            |
      | Simpson, Homer  |
     When I follow "Hinzufügen"
      And I wait for the modal box to appear
      And I fill in the following:
        | Vorname           | Carl    |
        | Nachname          | Carlson |
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see the following table of employees:
      | Name           |
      | Carlson, Carl  |
      | Simpson, Homer |

    Given a clear email queue
     When I go to the employees page for the organization "fukushima"
      And I follow "Einladen" within the cell "Aktion"/"Carlson, Carl"
      And I wait for the modal box to appear
      And I fill in "E-Mail" with "carl@carlson.com"
      And I press "Einladung verschicken"
     Then I should see that the invitation for "carl@carlson.com" and organization "fukushima" was successful
     When I sign out

     When I open the email with subject "Sie wurden zu Clockwork eingeladen"
     When I follow "Einladung akzeptieren" in the email
     Then I should see a flash notice "Vielen Dank, dass Sie Ihre Einladung bestätigen wollen. Sie müssen lediglich noch ein Passwort festlegen, um die Einladungsbestätigung erfolgreich abzuschließen."
     When I fill in "Passwort" with "secret!"
      And I fill in "invitation_user_attributes_password_confirmation" with "secret!"
      And I press "Passwort setzen"

  Scenario: Inviting an employee with an email address that does not exist yet
     When I invite the employee "homer" with the email address "homer@thesimpsons.com" for the organization "fukushima"
     Then I should see that the invitation for "homer@thesimpsons.com" and organization "fukushima" was successful
     When I sign out
     And the employee "homer" accepts the invitation for the organization "fukushima" with setting a password

  Scenario: Inviting an employee without entering an email address
    When I invite the employee "homer" with the email address "" for the organization "fukushima"
    Then I should see "muss ausgefüllt werden"

  Scenario: Accepting the same invitation a second time
    When I invite the employee "homer" with the email address "homer@thesimpsons.com" for the organization "fukushima"
    Then I should see that the invitation for "homer@thesimpsons.com" and organization "fukushima" was successful
    When I sign out
     And the employee "homer" accepts the invitation for the organization "fukushima" with setting a password

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
    When I invite the employee "homer" with the email address "homer@thesimpsons.com" for the organization "fukushima"
    Then I should see that the invitation for "homer@thesimpsons.com" and organization "fukushima" was successful
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

  Scenario: Inviting an employee with an email address of an unconfirmed user which has not been invited yet
    Given an account "tschernobyl" exists with name: "Tschernobyl GmbH"
      And an organization "überwachungszentrale" exists with name: "Überwachungszentrale"
      And a user "homer 2" exists with email: "homer@thesimpsons.com"
      And an employee "homer 2" exists with user: the user "homer 2", account: the account "tschernobyl"
      And a membership exists with organization: the organization "überwachungszentrale", employee: the employee "homer 2"
     Then the user "homer 2" should not be confirmed

     When I invite the employee "homer" with the email address "homer@thesimpsons.com" for the organization "fukushima"
     Then I should see that the invitation for "homer@thesimpsons.com" and organization "fukushima" was successful
     When I sign out
      And the employee "homer" accepts the invitation for the organization "fukushima" with setting a password
     Then the user "homer 2" should be confirmed

  Scenario: Reinviting an employee which has not accepted the invitation yet
    When I invite the employee "homer" with the email address "homer@thesimpsons.com" for the organization "fukushima"
    Then I should see that the invitation for "homer@thesimpsons.com" and organization "fukushima" was successful

    When I reinvite the employee "homer" with the email address "homer@thesimpsons.com" for the organization "fukushima"
    Then I should see that the invitation for "homer@thesimpsons.com" and organization "fukushima" was successful
    When I sign out
    And the employee "homer" accepts the invitation for the organization "fukushima" with setting a password

  Scenario: Displaying the e-mail address or the invitation status on the employees page
    When I go to the employees page for the organization "fukushima"
    Then I should see the following table of employees:
      | Name           | E-Mail               | Status                |
      | Simpson, Homer |                      | Noch nicht eingeladen |

    When I invite the employee "homer" with the email address "homer@thesimpsons.com" for the organization "fukushima"
    Then I should see that the invitation for "homer@thesimpsons.com" and organization "fukushima" was successful
    Then I should see the following table of employees:
      | Name           | E-Mail                | Status                                |
      | Simpson, Homer | homer@thesimpsons.com | Eingeladen am 23.05.2012 um 12:00 Uhr |

    Given today is "2012-05-24 12:00"
    # need to sign in again because the session has expired
    And I sign in as the confirmed user
    When I reinvite the employee "homer" with the email address "homer@thesimpsons.com" for the organization "fukushima"
    Then I should see that the invitation for "homer@thesimpsons.com" and organization "fukushima" was successful
    Then I should see the following table of employees:
      | Name           | E-Mail                | Status                                |
      | Simpson, Homer | homer@thesimpsons.com | Eingeladen am 24.05.2012 um 12:00 Uhr |
    And I sign out

    When the employee accepts the invitation for the organization "fukushima" with setting a password
    And I sign out

    And I sign in as the confirmed user
    When I go to the employees page for the organization "fukushima"
    Then I should see the following table of employees:
      | Name           | E-Mail                | Status |
      | Simpson, Homer | homer@thesimpsons.com | Aktiv  |


  Scenario: Inviting with an email that's already assigned to an employee of the same organization
   Given an employee "bart" exists with account: the account, first_name: "Bart"
     And a membership exists with organization: the organization, employee: the employee "bart"
    When I invite the employee "homer" with the email address "homer@thesimpsons.com" for the organization "fukushima"
    Then I should see that the invitation for "homer@thesimpsons.com" and organization "fukushima" was successful

    When I invite the employee "bart" with the email address "homer@thesimpsons.com" for the organization "fukushima"
    Then I should see "ist bereits vergeben"
     And "homer@thesimpsons.com" should receive no email

    When I invite the employee "bart" with the email address "bart@thesimpsons.com" for the organization "fukushima"
    Then I should see that the invitation for "bart@thesimpsons.com" and organization "fukushima" was successful


  Scenario: Inviting with an email that's already assigned to an employee of another organization of the same account
   Given an employee "homer 2" exists with account: the account, first_name: "Homer"
     And an organization "tschernobyl" exists with account: the account
     And a membership exists with organization: the organization "tschernobyl", employee: the employee "homer 2"

    When I invite the employee "homer 2" with the email address "homer@thesimpsons.com" for the organization "tschernobyl"
    Then I should see that the invitation for "homer@thesimpsons.com" and organization "tschernobyl" was successful

    When I invite the employee "homer" with the email address "homer@thesimpsons.com" for the organization "fukushima"
    Then I should see "ist bereits vergeben"
     And "homer@thesimpsons.com" should receive no email

    When I invite the employee "homer" with the email address "homer.simpson@fukushima.com" for the organization "fukushima"
    Then I should see that the invitation for "homer.simpson@fukushima.com" and organization "fukushima" was successful


  Scenario: Inviting with an email that's already assigned to an employee of a different account
    Given an account "tschernobyl" exists with name: "Tschernobyl GmbH"
      And an organization "überwachungszentrale" exists with name: "Überwachungszentrale", account: the account "tschernobyl"
      And a confirmed user "homer 2" exists with email: "homer@thesimpsons.com"
      And an employee "homer 2" exists with user: the confirmed user "homer 2", account: the account "tschernobyl"
      And a membership exists with organization: the organization "überwachungszentrale", employee: the employee "homer 2"

     When I invite the employee "homer" with the email address "homer@thesimpsons.com" for the organization "fukushima"
     Then I should see that the invitation for "homer@thesimpsons.com" and organization "fukushima" was successful
     When I sign out
      And the employee "homer" accepts the invitation for the organization "fukushima" without setting a password

