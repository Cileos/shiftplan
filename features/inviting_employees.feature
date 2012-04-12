@javascript
Feature: Inviting Employees
  As a planner
  I want to invite my employees
  So that they can see when they have to work and can comment on plans and shifts

  Background:
    Given today is "2012-05-23 12:00"
      And an organization "fukushima" exists with name: "Fukushima"
      And a confirmed user exists with email: "planner@fukushima.jp"
      And a planner exists with first_name: "Planner", last_name: "Burns", user: the confirmed user, organization: the organization

      And an employee "homer" exists with organization: organization "fukushima", first_name: "Homer"
     When I sign in as the confirmed user

  Scenario: Inviting an employee with an email address that does not exist yet
     When I invite the employee "homer" with the email address "homer@thesimpsons.com" for the organization "fukushima"
     Then I should see that the invitation for "homer@thesimpsons.com" and organization "fukushima" was successful
     When I sign out
     And the employee "homer" accepts the invitation for the organization "fukushima" with setting a password

  Scenario: Accepting the same invitation two times
    When I invite the employee "homer" with the email address "homer@thesimpsons.com" for the organization "fukushima"
    Then I should see that the invitation for "homer@thesimpsons.com" and organization "fukushima" was successful
    When I sign out
     And the employee "homer" accepts the invitation for the organization "fukushima" with setting a password
    When I sign out
    # accept invitation again
    When I open the email with subject "Sie wurden zu Shiftplan eingeladen"
     And I follow "Einladung akzeptieren" in the email
    Then I should be on the signin page
     And I should see "Sie haben diese Einladung bereits akzeptiert."
     And I should see "Bitte loggen Sie sich mit Ihrer E-Mail Adresse und Ihrem Passwort ein."

  Scenario: Inviting an employee with an email address of a confirmed user which has not been invited yet
    Given a confirmed user "homer" exists with email: "homer@thesimpsons.com"
      When I invite the employee "homer" with the email address "homer@thesimpsons.com" for the organization "fukushima"
     Then I should see that the invitation for "homer@thesimpsons.com" and organization "fukushima" was successful
     When I sign out
      And the employee "homer" accepts the invitation for the organization "fukushima" without setting a password

  Scenario: Inviting an employee with an email address of an unconfirmed user which has not been invited yet
    Given a user "homer" exists with email: "homer@thesimpsons.com"
     Then the user "homer" should not be confirmed
     When I invite the employee "homer" with the email address "homer@thesimpsons.com" for the organization "fukushima"
     Then I should see that the invitation for "homer@thesimpsons.com" and organization "fukushima" was successful
     When I sign out
      And the employee "homer" accepts the invitation for the organization "fukushima" with setting a password
     Then the user "homer" should be confirmed

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
      | Name          | E-Mail               | Status   |
      | Planner Burns | planner@fukushima.jp | Aktiv    |
      | Homer Simpson |                      | Einladen |

    When I invite the employee "homer" with the email address "homer@thesimpsons.com" for the organization "fukushima"
    Then I should see that the invitation for "homer@thesimpsons.com" and organization "fukushima" was successful
    Then I should see the following table of employees:
      | Name          | E-Mail                | Status                                          |
      | Planner Burns | planner@fukushima.jp  | Aktiv                                           |
      | Homer Simpson | homer@thesimpsons.com | Erneut einladen\nEingeladen am 23.05.2012 12:00 |

    Given today is "2012-05-24 12:00"
    # need to sign in again because the session has expired
    And I sign in as the confirmed user
    When I reinvite the employee "homer" with the email address "homer@thesimpsons.com" for the organization "fukushima"
    Then I should see the following table of employees:
      | Name          | E-Mail                | Status                                          |
      | Planner Burns | planner@fukushima.jp  | Aktiv                                           |
      | Homer Simpson | homer@thesimpsons.com | Erneut einladen\nEingeladen am 24.05.2012 12:00 |
    When I sign out

    When the employee accepts the invitation for the organization "fukushima" with setting a password
    And I sign out
    And I sign in as the confirmed user
    When I go to the employees page for the organization "fukushima"
    Then I should see the following table of employees:
      | Name          | E-Mail                | Status |
      | Planner Burns | planner@fukushima.jp  | Aktiv  |
      | Homer Simpson | homer@thesimpsons.com | Aktiv  |

  Scenario: Inviting with an email that's already assigned to an employee of the same organization
    Given an employee "bart" exists with organization: organization "fukushima", first_name: "Bart"
    When I invite the employee "homer" with the email address "homer@thesimpsons.com" for the organization "fukushima"
    Then I should see that the invitation for "homer@thesimpsons.com" and organization "fukushima" was successful

    When I invite the employee "bart" with the email address "homer@thesimpsons.com" for the organization "fukushima"
    Then I should see "Sie haben bereits den Mitarbeiter Homer Simpson mit der E-Mail Adresse homer@thesimpsons.com eingeladen"

    When I invite the employee "bart" with the email address "bart@thesimpsons.com" for the organization "fukushima"
    Then I should see that the invitation for "bart@thesimpsons.com" and organization "fukushima" was successful

  Scenario: Inviting with an email that's already assigned to an employee of a different organization
    Given an organization "tschernobyl" exists with name: "Tschernobyl"
      And a confirmed user "mr. burns" exists
      And a planner "mr. burns" exists with user: the confirmed user "mr. burns", organization: the organization "tschernobyl"
      And an employee "ray atom" exists with organization: organization "tschernobyl", first_name: "Ray", last_name: "Atom"

     When I invite the employee "homer" with the email address "homer@thesimpsons.com" for the organization "fukushima"
     Then I should see that the invitation for "homer@thesimpsons.com" and organization "fukushima" was successful
     When I sign out
      And the employee "homer" accepts the invitation for the organization "fukushima" with setting a password
     When I sign out

     When I sign in as the confirmed user "mr. burns"
     When I invite the employee "ray atom" with the email address "homer@thesimpsons.com" for the organization "tschernobyl"
     Then I should see that the invitation for "homer@thesimpsons.com" and organization "tschernobyl" was successful

     When I sign out
      And the employee "ray atom" accepts the invitation for the organization "tschernobyl" without setting a password