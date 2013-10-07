@javascript
Feature: Manage schedulings without teams
  As a planner
  I want to create and update schedulings without a team
  and see it in the without team row in the calendar

  Background:
    Given today is 2012-02-13
      And the situation of a nuclear reactor

  Scenario: creating a scheduling without a team by clicking in the without team row
    Given I choose "Teams" from the drop down "Mitarbeiter" within the calendar
     When I click on cell "Mo"/"Ohne Team"
      And I wait for the modal box to appear
      And I schedule "22-6"
      And I press "Anlegen"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
        | Teams      | Mo           | Di           | Mi  | Do  | Fr  | Sa  | So  |
        | Ohne Team  | 22:00-06:00  | 22:00-06:00  |     |     |     |     |     |

  Scenario: editing a scheduling without a team
    Given the employee "Homer" was scheduled in the plan as following:
        | date       | quickie |
        | 2012-02-15 | 22-6    |
      And I choose "Teams" from the drop down "Mitarbeiter" within the calendar
     Then I should see the following calendar:
        | Teams      | Mo  | Di  | Mi                   | Do                   | Fr  | Sa  | So  |
        | Ohne Team  |     |     | Homer S 22:00-06:00  | Homer S 22:00-06:00  |     |     |     |
     When I click on scheduling "22:00-06:00"
      And I wait for the modal box to appear
      And I fill in "Endzeit" with "07:00"
      And I select "Lenny L" from "Mitarbeiter"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
        | Teams      | Mo  | Di  | Mi                   | Do                   | Fr  | Sa  | So  |
        | Ohne Team  |     |     | Lenny L 22:00-07:00  | Lenny L 22:00-07:00  |     |     |     |
