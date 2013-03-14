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

     When I click on the scheduling "07:00-23:00"
      And I wait for the modal box to appear
     Then I should see "9-17 wichtige Arbeit [wA]" within a hint
     Then I should be able to change the "Quickie" from "7-23" to "1-23" and select "Lenny L" as "Mitarbeiter"
      And I should see the following partial calendar:
        | Mitarbeiter  | Fr           |
        | Carl C       |              |
        | Lenny L      | 01:00-23:00  |
        | Homer S      |              |
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
     Then the scheduling "04:00-10:00" should be focus within the cell "Fr"/"Lenny L"

     When I press return
      And I wait for the modal box to appear
     Then the "Quickie" field should contain "4-10" within the modal box

     When I press escape
      And I wait for the modal box to disappear
      And I press key "e"
     Then I should be able to change the "Quickie" from "4-10" to "4-11" and select "Lenny L" as "Mitarbeiter"
      And I should see the following partial calendar:
        | Mitarbeiter | Fr                                  |
        | Carl C      |                                     |
        | Lenny L     | 01:00-03:00 04:00-11:00 12:00-23:00 |
        | Homer S     |                                     |
      And the scheduling "04:00-11:00" should be focus within the cell "Fr"/"Lenny L"
