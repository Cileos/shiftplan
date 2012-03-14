@javascript
Feature: Inviting Employees
  As a planner
  I want to invite my employees
  So that they can see when they have to work and can comment on plans and shifts

  Background:
    Given today is "2012-05-23 12:00"
      And a planner "me" exists with email: "planner@fukushima.jp"
      And an organization "fukushima" exists with name: "Fukushima", planner: planner "me"
      And an employee "homer" exists with organization: organization "fukushima", first_name: "Homer"
      And a plan exists with organization: the organization, name: "Schicht im Schacht"
     When I sign in as the planner "me"
     Then I should be signed in as "planner@fukushima.jp" for the organization

  Scenario: Inviting an employee with an email address that does not exist yet
     When I invite the employee "homer" with the email address "homer@thesimpsons.com"
     Then I should see that the invitation for "homer@thesimpsons.com" was successful
     And the employee "homer" accepts the invitation with setting a password

  Scenario: Inviting an employee with an email address of a confirmed user which has not been invited yet
    Given a confirmed user "homer" exists with email: "homer@thesimpsons.com"
      And a clear email queue
      When I invite the employee "homer" with the email address "homer@thesimpsons.com"
     Then I should see that the invitation for "homer@thesimpsons.com" was successful
      And the employee "homer" accepts the invitation without setting a password

  Scenario: Inviting an employee with an email address of an unconfirmed user which has not been invited yet
    Given a user "homer" exists with email: "homer@thesimpsons.com"
     Then the user "homer" should not be confirmed
      And a clear email queue
     When I invite the employee "homer" with the email address "homer@thesimpsons.com"
     Then I should see that the invitation for "homer@thesimpsons.com" was successful
      And the employee "homer" accepts the invitation with setting a password
     Then the user "homer" should be confirmed

  Scenario: Reinviting an employee which has not accepted the invitation yet
    When I invite the employee "homer" with the email address "homer@thesimpsons.com"
    Then I should see that the invitation for "homer@thesimpsons.com" was successful

    When I reinvite the employee "homer" with the email address "homer@thesimpsons.com"
    Then I should see that the invitation for "homer@thesimpsons.com" was successful
    And the employee "homer" accepts the invitation with setting a password

  Scenario: Displaying the e-mail address or the invitation status on the employees page
    When I go to the employees page
    Then I should see the following table of employees:
      | Name          | E-Mail   |
      | Homer Simpson | Einladen |

    When I invite the employee "homer" with the email address "homer@thesimpsons.com"
    Then I should see that the invitation for "homer@thesimpsons.com" was successful
    Then I should see the following table of employees:
      | Name          | E-Mail                                         |
      | Homer Simpson | Erneut einladen\nEingeladen am 23.05.2012 12:00 |

    Given today is "2012-05-24 12:00"
    # need to sign in again because the session has expired
    And I sign in as the planner "me"
    When I reinvite the employee "homer" with the email address "homer@thesimpsons.com"
    Then I should see the following table of employees:
      | Name          | E-Mail                                         |
      | Homer Simpson | Erneut einladen\nEingeladen am 24.05.2012 12:00 |

    When the employee accepts the invitation with setting a password
    And I sign out
    And I sign in as the planner "me"
    When I go to the employees page
    Then I should see the following table of employees:
      | Name          | E-Mail                |
      | Homer Simpson | homer@thesimpsons.com |

  Scenario: Inviting with an email that's already assigned to an employee of the same organization
    Given an employee "bart" exists with organization: organization "fukushima", first_name: "Bart"
    When I invite the employee "homer" with the email address "homer@thesimpsons.com"
    Then I should see that the invitation for "homer@thesimpsons.com" was successful

    When I invite the employee "bart" with the email address "homer@thesimpsons.com"
    Then I should see "Sie haben bereits den Mitarbeiter Homer Simpson mit der E-Mail Adresse homer@thesimpsons.com eingeladen"

    When I invite the employee "bart" with the email address "bart@thesimpsons.com"
    Then I should see that the invitation for "bart@thesimpsons.com" was successful

  @todo
  Scenario: Inviting with an email that's already assigned to an employee of a different organization

  # TODO: Invitation status so anpassen, dass dieser von der Organisation abhängig ist.
  # Bsp: Employee "homer" ist für Organisation "nuklear" bereits eingeladen worden. Jedoch nicht für
  # Organisation "fukushima". Dann sollte der Invitation status für Organisation "fukishima" auch
  # "Sie haben diesen Mitarbeiter noch nicht eingeladen lauten."

  # remember for which account an user has accepted an invitation? brauchen wir nicht, aber mal prüfen


