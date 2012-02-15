Feature: Creating a plan
  In order to schedule work in my organization
  As a planner
  I want to create a plan

  Scenario: creating a weekly plan for the current organization
    Given a planner exists
      And an organization exists with planner: the planner
      And the organization has the following employees:
        | first_name | last_name |
        | Homer      | S         |
        | Lenny      | L         |
        | Carl       | C         |
      # monday
      And today is 2012-02-01
      And I am signed in as the planner

     When I follow "neuer Plan"
      # duration of plan is fixed for now
      #And I choose "Woche"
      #And I press "Weiter"
      And I fill in "Name" with "Halloween im Atomkraftwerk"
      And I select "KW 07 13.02.2012" from "Woche"
      And I press "Anlegen"

     Then a plan should exist with organization: the organization, name: "Halloween im Atomkraftwerk"
      And I should be on the page for the plan
      And the page should be titled "Halloween im Atomkraftwerk"
      And I should see the following calendar:
        | Mitarbeiter | Montag | Dienstag | Mittwoch | Donnerstag | Freitag | Samstag | Sonntag |
        | Carl C      |        |          |          |            |         |         |         |
        | Lenny L     |        |          |          |            |         |         |         |
        | Homer S     |        |          |          |            |         |         |         |
