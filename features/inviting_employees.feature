Feature: Inviting Employees
  As a planner
  I want to invite my employees
  So that they can see when they have to work and can comment on plans and shifts

  Background:
    Given today is "2012-01-01 12:00"
      And a planner "me" exists with email: "planner@fukushima.jp"
      And an organization "fukushima" exists with name: "Fukushima", planner: planner "me"
      And an employee "homer" exists with organization: organization "fukushima", first_name: "Homer"
      And a plan exists with organization: the organization, name: "Schicht im Schacht"
     When I sign in as the planner "me"
     Then I should be signed in as "planner@fukushima.jp" for the organization

  Scenario: Inviting an employee with an email address that does not exist yet
     When I invite the employee "homer" with the email address "homer@thesimpsons.com"

      And the employee "homer" accepts the invitation with setting a password
     Then I should be signed in as "homer@thesimpsons.com" for the organization
      And I should see "Vielen Dank, dass Sie Ihre Einladung zu Shiftplan akzeptiert haben."
      And I should be on the dashboard page
      And I should see "Schicht im Schacht"

     When I follow "Ausloggen"
      And I sign in as the planner "me"
      And go to the edit page of the employee
     Then I should see "Sie haben diesen Mitarbeiter am 01. Januar, 12:00 Uhr eingeladen."
      And I should see "Die Einladung wurde am 01. Januar, 12:00 Uhr akzeptiert."

  Scenario: Inviting an employee with an email address of a confirmed user which has not been invited yet
    Given a confirmed user "homer" exists with email: "homer@thesimpsons.com"
      And a clear email queue

     When I invite the employee "homer" with the email address "homer@thesimpsons.com"

      And the employee "homer" accepts the invitation without setting a password
     Then I should be signed in as "homer@thesimpsons.com" for the organization
      And I should see "Vielen Dank, dass Sie Ihre Einladung zu Shiftplan akzeptiert haben."
      And I should be on the dashboard page
      And I should see "Schicht im Schacht"

  Scenario: Inviting an employee with an email address of an unconfirmed user which has not been invited yet
    Given a user "homer" exists with email: "homer@thesimpsons.com"
     Then the user "homer" should not be confirmed
      And a clear email queue

     When I invite the employee "homer" with the email address "homer@thesimpsons.com"

      And the employee "homer" accepts the invitation with setting a password
     Then the user "homer" should be confirmed
      And I should be signed in as "homer@thesimpsons.com" for the organization
      And I should see "Vielen Dank, dass Sie Ihre Einladung zu Shiftplan akzeptiert haben."
      And I should be on the dashboard page
      And I should see "Schicht im Schacht"

  Scenario: Reinviting an employee which has not accepted the invitation yet
    When I invite the employee "homer" with the email address "homer@thesimpsons.com"

    When I reinvite the employee "homer" with the email address "homer@thesimpsons.com"
      And the employee "homer" accepts the invitation with setting a password
     Then I should be signed in as "homer@thesimpsons.com" for the organization
      And I should see "Vielen Dank, dass Sie Ihre Einladung zu Shiftplan akzeptiert haben."
      And I should be on the dashboard page
      And I should see "Schicht im Schacht"

  # TODO: Invitation status so anpassen, dass dieser von der Organisation abhängig ist.
  # Bsp: Employee "homer" ist für Organisation "nuklear" bereits eingeladen worden. Jedoch nicht für
  # Organisation "fukushima". Dann sollte der Invitation status für Organistation "fukishima" auch
  # "Sie haben diesen Mitarbeiter noch nicht eingeladen lauten."
  #
  # TODO for later: What if invited and already confirmed user logs in without having accepted the invitation?
  # What should happen? Should she be allowed to access the organization's plans for which she has been
  # invited? Maybe show an info after logging in that shows her unaccepted invitations?
  #
  # TODO: Show invitation status on show and index view, too???
  #
  # TODO: If user logging in (either as planner or normal employee) is assigned/was invited to more than
  # one organisation let him select on dashboard first for which organization he wants to log in.


