@javascript
Feature: Edit Schedulings of a Plan
  In order to fix typing errors or adapt to new circumstances
  As a planner
  I want to edit schedulings in my plan

  Background:
    # week 49
    Given today is 2012-12-18
      And the situation of a nuclear reactor

  Scenario: Edit a single scheduling
    Given the employee "Lenny" was scheduled in the plan as following:
        | date       | quickie |
        | 2012-12-21 | 7-23    |
      And I am on the page for the plan

     When I click on the scheduling "7-23"
      And I wait for the modal box to appear
     Then I should see "9-17 wichtige Arbeit [wA]" within a hint
     Then I should be able to change the "Quickie" from "7-23" to "1-23" and select "Lenny L" as "Mitarbeiter"
      And I should see the following calendar:
        | Mitarbeiter | Fr   |
        | Carl C      |      |
        | Lenny L     | 1-23 |
        | Homer S     |      |
      And the employee "Lenny L" should have a grey hours/waz value of "22"

  Scenario: Edit a scheduling in a cell with multiple schedulings
    Given the employee "Lenny" was scheduled in the plan as following:
        | date       | quickie |
        | 2012-12-21 | 1-3     |
        | 2012-12-21 | 4-10    |
        | 2012-12-21 | 12-23   |
      And I am on the page for the plan
     When I press arrow right 4 times
      And I press arrow down 2 times
     Then the scheduling "4-10" should be focus within the cell "Fr"/"Lenny L"

     When I press return
      And I wait for the modal box to appear
     Then the "Quickie" field should contain "4-10" within the modal box

     When I press escape
      And I wait for the modal box to disappear
      And I press key "e"
     Then I should be able to change the "Quickie" from "4-10" to "4-11" and select "Lenny L" as "Mitarbeiter"
      And I should see the following calendar:
        | Mitarbeiter | Fr             |
        | Carl C      |                |
        | Lenny L     | 1-3 4-11 12-23 |
        | Homer S     |                |
      And the scheduling "4-11" should be focus within the cell "Fr"/"Lenny L"
