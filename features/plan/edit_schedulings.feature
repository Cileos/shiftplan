@javascript
Feature: Edit Schedulings of a Plan
  In order to fix typing errors or adapt to new circumstances
  As a planner
  I want to edit schedulings in my plan

  Background:
    Given an organization exists
      And a confirmed user exists
      And an employee planner exists with first_name: "Santa", last_name: "C", user: the confirmed user, organization: the organization
      # week 49
      And today is 2012-12-18
      And a plan exists with organization: the organization
      And I am signed in as the confirmed user



  Scenario: Edit a single scheduling
    Given the employee was scheduled in the plan as following:
        | date       | quickie |
        | 2012-12-21 | 7-23    |
      And I am on the page for the plan

     When I click on the scheduling "7-23"
      And I wait for the modal box to appear
     Then the "Quickie" field should contain "7-23" within the modal box

     # invalid Quickie produces error
     When I fill in "Quickie" with "1-" within the modal box
      And I press "Speichern"
     Then I should see "Quickie ist nicht gültig" within errors within the modal box

     When I fill in "Quickie" with "1-23" within the modal box
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
        | Mitarbeiter | Fr   |
        | Santa C     | 1-23 |
      And the employee "Santa C" should have a grey hours/waz value of "22"

  Scenario: Edit a scheduling in a cell with multiple schedulings
    Given the employee was scheduled in the plan as following:
        | date       | quickie |
        | 2012-12-21 | 1-3     |
        | 2012-12-21 | 4-10    |
        | 2012-12-21 | 12-23   |
      And I am on the page for the plan
     When I press arrow right 4 times
      And I press arrow down
     Then the scheduling "4-10" should be focus within the cell "Fr"/"Santa C"

     When I press return
      And I wait for the modal box to appear
     Then the "Quickie" field should contain "4-10" within the modal box

     When I press escape
      And I wait for the modal box to disappear
      And I press key "e"
        And I wait for the modal box to appear
     Then the "Quickie" field should contain "4-10" within the modal box

     When I fill in "Quickie" with "4-11" within the modal box
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
        | Mitarbeiter | Fr             |
        | Santa C     | 1-3 4-11 12-23 |
      And the scheduling "4-11" should be focus within the cell "Fr"/"Santa C"
