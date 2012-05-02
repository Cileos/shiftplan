Feature: Delete schedulings from plan
  In order to manually move an employee from one day to another
  As a planner
  I want to delete a single scheduling

  Background:
    Given an organization exists
      And a confirmed user exists
      And an employee planner exists with first_name: "Santa", last_name: "C", user: the confirmed user, organization: the organization
      # week 49
      And today is 2012-12-18
      And a plan exists with organization: the organization
      And I am signed in as the confirmed user

      And the employee was scheduled in the plan as following:
        | date       | quickie |
        | 2012-12-20 | 7-17    |
        | 2012-12-21 | 5-23    |
      And I am on the page for the plan

      And I should see the following calendar:
        | Mitarbeiter | Donnerstag | Freitag | Stunden |
        | Santa C     | 7-17       | 5-23    | 28      |

  @javascript
  Scenario: Delete a single scheduling
    Given I click on cell "Freitag"/"Santa C"
      And I wait for the modal box to appear
     When I follow "Löschen" within the first form within the modal box
     Then the edit scheduling form should disappear
      But the modal box should be visible
      And I should not see "Löschen" within the first form within the modal box
      And the "Quickie" field should contain "5-23" within the first form within the modal box
      And I should see the following calendar:
        | Mitarbeiter | Donnerstag | Freitag | Stunden |
        | Santa C     | 7-17       |         | 10      |

      # Undo / Move
     When I select "Samstag" from "Wochentag"
      And I press "Anlegen"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
        | Mitarbeiter | Donnerstag | Freitag | Samstag | Stunden |
        | Santa C     | 7-17       |         | 5-23    | 28      |
