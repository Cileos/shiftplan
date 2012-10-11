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
     When I fill in "Beschreibung" with "5 eyes minimum"
      And I press "Anlegen"

     Then a plan should exist with organization: the organization, name: "Halloween im Atomkraftwerk"
      And I should be on the employees in week page for the plan for week: 5, year: 2012
      And the page should be titled "Halloween im Atomkraftwerk"
      And I should see "5 eyes minimum"
      And I should see a calendar titled "Halloween im Atomkraftwerk - KW 05 30.01.2012"
      And I should see the following calendar:
        | Mitarbeiter   | Mo | Di | Mi | Do | Fr | Sa | So |
        | Carl C        |    |    |    |    |    |    |    |
        | Lenny L       |    |    |    |    |    |    |    |
        | Homer S       |    |    |    |    |    |    |    |

  # in germany, the week with january 4th is the first calendar week
  # in 2012, the January 1st is a sunday
  Scenario: creating a plan by name for the current organization with a specific period locks the user in this time period frame
      # monday 4 weeks from now (9th week, german)
     When I fill in "Startdatum" with "2012-02-27"
      # friday a month later (13th week, german)
      And I fill in "Enddatum" with "2012-03-30"
      And I press "Anlegen"
     Then a plan should exist with organization: the organization, name: "Halloween im Atomkraftwerk"
      And I should be on the employees in week page for the plan for week: 9, year: 2012
      And I should not see "<" within the calendar navigation
      But I should see ">" within the calendar navigation

     When I go to the employees in week page for the plan for week: 23, year: 2012
     Then I should be on the employees in week page for the plan for week: 13, year: 2012
      And I should not see ">" within the calendar navigation
      But I should see "<" within the calendar navigation

