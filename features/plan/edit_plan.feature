@javascript
Feature: Editing plans
  As a planner
  I want to edit plans
  In order to be able to change properties of plans later on

  Background:
    Given the situation of a nuclear reactor

  Scenario: Editing a plan without schedulings
    Given 0 schedulings should exist with plan: the plan "clean reactor"
      And I go to the plans page of the organization
     Then I should see the following table of plans:
        | Name                       | Beschreibung   | Startdatum | Enddatum   |
        | Cleaning the Reactor       |                | -          | -          |

     When I follow "Bearbeiten" within the first table row
      And I wait for the modal box to appear
      And I fill in "Name" with "Cleaning the Reactor B"
      And I fill in "Beschreibung" with "Reactor B needs to be cleaned properly"
      And I fill in "Startdatum" with "01.01.2012"
      And I fill in "Enddatum" with "02.02.2012"
      And I close all datepickers
      And I press "Speichern"
      And I wait for the modal box to disappear

     Then I should be on the plans page of the organization
      And I should see the following table of plans:
        | Name                   | Beschreibung                           | Startdatum | Enddatum   |
        | Cleaning the Reactor B | Reactor B needs to be cleaned properly | 01.01.2012 | 02.02.2012 |
