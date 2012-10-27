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


  Scenario: Editing the start date of a plan with schedulings
    # scheduling on 10.12.2012 9-17
    Given the employee "Homer" was scheduled in the plan as following:
        | year | week | cwday | quickie |
        | 2012 | 50   | 1     | 9-17    |
      And I go to the plans page of the organization
     Then I should see the following table of plans:
        | Name                       | Beschreibung   | Startdatum | Enddatum   |
        | Cleaning the Reactor       |                | -          | -          |

     When I follow "Bearbeiten" within the first table row
      And I wait for the modal box to appear
      # one day after the scheduling
      And I fill in "Startdatum" with "11.12.2012"
      And I close all datepickers
      And I press "Speichern"

     Then I should see "Startdatum kann nicht geändert werden." within errors
      And I should see "Es existiert bereits ein Eintrag für diesen Plan, der kleiner als das neue Startdatum ist." within errors
      And I should see "Der kleinste Eintrag ist am 10.12.2012" within errors

     # at the day of the scheduling
     When I fill in "Startdatum" with "10.12.2012"
      And I close all datepickers
      And I press "Speichern"
      And I wait for the modal box to disappear

     Then I should be on the plans page of the organization
      And I should see the following table of plans:
        | Name                 | Beschreibung | Startdatum | Enddatum |
        | Cleaning the Reactor |              | 10.12.2012 | -        |
