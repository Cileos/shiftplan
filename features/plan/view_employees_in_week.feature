@javascript
Feature: View as employees in week (first one)

  Background:
    Given today is 2012-12-04
      And the situation of a nuclear reactor

  Scenario: move a scheduling from one employee to the other
    Given the employee "Homer" was scheduled in the plan as following:
        | week | cwday | quickie |
        | 49   | 1     | 9-17    |
      And I am on the page of the plan
     Then I should be on the employees in week page for the plan for year: 2012, week: 49
      And the employee "Homer S" should have a yellow hours/waz value of "8 / 40"
      And the employee "Lenny L" should have a grey hours/waz value of "0"
     When I click on scheduling "09:00-17:00"
      And I change the "Quickie" from "9-17" to "9-17" and select "Lenny L" as "Mitarbeiter"
     Then I should be on the employees in week page for the plan for year: 2012, week: 49
      And I should see the following calendar:
        | Mitarbeiter  | Mo           | Di  | Mi  | Do  | Fr  | Sa  | So  |
        | Carl C       |              |     |     |     |     |     |     |
        | Lenny L      | 09:00-17:00  |     |     |     |     |     |     |
        | Homer S      |              |     |     |     |     |     |     |
      And the employee "Homer S" should have a yellow hours/waz value of "0 / 40"
      And the employee "Lenny L" should have a grey hours/waz value of "8"


