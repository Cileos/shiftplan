@javascript
Feature: Creating a plan
  In order to schedule work in my organization
  As a planner
  I want to create a plan

  Background:
    Given today is 2012-02-01
      # monday
      And the situation of a nuclear reactor
      And I am on the page for the organization "Reactor"
      When I choose "Alle Pläne" from the drop down "Pläne"
      And I follow "Hinzufügen"
      And I wait for the modal box to appear
      And I fill in "Name" with "Halloween im Atomkraftwerk"

  Scenario: creating a plan by name for the current organization
     When I press "Anlegen"

     Then a plan should exist with organization: the organization, name: "Halloween im Atomkraftwerk"
      And I should be on the employees in week page for the plan for week: 5, year: 2012
      And the page should be titled "Halloween im Atomkraftwerk"
      And I should see a calendar titled "Halloween im Atomkraftwerk - KW 05 30.01.2012"
      And I should see the following calendar:
        | Mitarbeiter   | Mo | Di | Mi | Do | Fr | Sa | So |
        | Planner Burns |    |    |    |    |    |    |    |
        | Carl C        |    |    |    |    |    |    |    |
        | Lenny L       |    |    |    |    |    |    |    |
        | Homer S       |    |    |    |    |    |    |    |

  Scenario: creating a plan by name for the current organization with a specific period
      # monday 4 weeks from now (10th week)
     When I fill in "Startdatum" with "27.02.2012"
      # friday a month later (14th week)
      And I fill in "Enddatum" with "30.03.2012"
      And I press "Anlegen"
     Then a plan should exist with organization: the organization, name: "Halloween im Atomkraftwerk"
      And I should be on the employees in week page for the plan for week: 10, year: 2012
      And I should not see "<" within the calendar navigation
      But I should see ">" within the calendar navigation

     When I go to the employees in week page for the plan for week: 23, year: 2012
     Then I should be on the employees in week page for the plan for week: 14, year: 2012
      And I should not see ">" within the calendar navigation
      But I should see "<" within the calendar navigation

