Feature: create a scheduling
  In order for my employees not to miss any of their shifts
  As a planner
  I want to create a scheduling for my employees

  Background:
    Given a planner exists
      And an organization exists with planner: the planner
      And the organization has the following employees:
        | first_name | last_name |
        | Homer      | S         |
        | Lenny      | L         |
        | Carl       | C         |
      And a plan exists with organization: the organization, name: "Der Plan"
      And today is 2012-02-13
      And I am signed in as the planner


  Scenario: just entering time span
     When I follow "Der Plan"
      And I follow "Neue Terminierung"
      And I select "Homer S" from "Mitarbeiter"
      And I select "Mittwoch" from "Wochentag"
      And I fill in "Quickie" with "9-17"
      And I press "Anlegen"
     Then I should see the following calendar:
        | Mitarbeiter | Montag | Dienstag | Mittwoch | Donnerstag | Freitag | Samstag | Sonntag |
        | Carl C      |        |          |          |            |         |         |         |
        | Lenny L     |        |          |          |            |         |         |         |
        | Homer S     |        |          | 9-17     |            |         |         |         |


  @javascript
  Scenario: just entering time span with javascript
     When I follow "Der Plan"
      And I wait for the calendar to appear
      And I schedule "Homer S" on "Donnerstag" for "8-18"
     Then I should see the following calendar:
        | Mitarbeiter | Montag | Dienstag | Mittwoch | Donnerstag | Freitag | Samstag | Sonntag |
        | Carl C      |        |          |          |            |         |         |         |
        | Lenny L     |        |          |          |            |         |         |         |
        | Homer S     |        |          |          | 8-18       |         |         |         |


  @todo
  Scenario: display validation errors
