@javascript
Feature: Plan a week

  Background:
    Given today is 2012-12-04
      And the situation of a nuclear reactor


  # TODO do not copy schedulings of deactivated employee
  Scenario: copy from last week
    Given the employee "Homer" was scheduled in the plan as following:
        | week | cwday | quickie |
        | 48   | 1     | 5-7     |
        | 49   | 2     | 10-11   |
        | 49   | 3     | 11-12   |
        | 49   | 4     | 12-13   |
      And I am on the employees in week page of the plan for week: 50, year: 2012
     When I follow "Übernahme aus der letzten Woche"
      And I wait for the modal box to appear
      And I select "KW 49 03.12.2012" from "Von"
      And I press "Übernehmen"
     Then I should be on the employees in week page of the plan for year: 2012, week: 50
      And I should see a calendar titled "Cleaning the Reactor - KW 50 10.12.2012"
      And I should see the following calendar:
        | Mitarbeiter | Mo | Di    | Mi    | Do    | Fr |
        | Homer S     |    | 10-11 | 11-12 | 12-13 |    |
