Feature: Edit Schedulings of a Plan
  In order to fix typing errors or adapt to new circumstances
  As a planer
  I want to edit schedulings in my plan

  Background:
    Given a planner exists
      # week 49
      And today is 2012-12-18
      And an organization exists with planner: the planner
      And a plan exists with organization: the organization
      And a employee exists with first_name: "Santa", organization: the organization, last_name: "C"
      And I am signed in as the planner


  @javascript
  Scenario: Edit a single scheduling
    Given the employee was scheduled in the plan as following:
        | date       | quickie |
        | 2012-12-21 | 7-23    |
      And I am on the page for the plan
      And I should see the following calendar:
        | Mitarbeiter | Freitag | Stunden |
        | Santa C     | 7-23    | 16      |

     When I click on cell "Freitag"/"Santa C"
      And I wait for the modal box to appear
      And the "Quickie" field should contain "7-23"

     When I fill in "Quickie" with "1-23"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
        | Mitarbeiter | Freitag | Stunden |
        | Santa C     | 1-23    | 22      |
