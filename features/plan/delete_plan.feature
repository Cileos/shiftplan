@javascript
Feature: Deleting plans
  As a planner
  I want to delete plans
  In order to remove plans I do not need

  Background:
    Given the situation of a nuclear reactor

  Scenario: Deleting a plan without schedulings
    Given 0 schedulings should exist with plan: the plan "clean reactor"
      And I go to the plans page of the organization
     Then I should see the following table of plans:
        | Name                       | Beschreibung   | Startdatum | Enddatum   |
        | Cleaning the Reactor       |                | -          | -          |

     When I deactivate all confirm dialogs
      And I follow "Löschen" within the first table row
     Then I should be on the plans page of the organization
      And I should see "Es wurden noch keine Pläne angelegt"
