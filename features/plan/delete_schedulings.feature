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
        | 2012-12-21 | 2-4     |
        | 2012-12-21 | 5-23    |
      And I am on the page for the plan

      And I should see the following calendar:
        | Mitarbeiter | Donnerstag | Freitag  | Stunden/WAZ |
        | Santa C     | 7-17       | 2-4 5-23 | 30          |

  @javascript
  Scenario: Delete a single scheduling
    Given I click on cell "Freitag"/"Santa C"
      And I wait for the modal box to appear
     Then the "Quickie" field should contain "2-4" within the first active tab
      And the "Quickie" field should contain "5-23" within the second active tab
     When I follow "Löschen" within the second active tab within the modal box body
     Then the second active tab should disappear
      But the modal box should be visible
      And I should see "Löschen" within the first active tab within the modal box body
      And the "Quickie" field should contain "2-4" within the first active tab within the modal box body
      And the "Quickie" field should contain "5-23" within the new scheduling form within the modal box body
      And I should see the following calendar:
        | Mitarbeiter | Donnerstag | Freitag | Stunden/WAZ |
        | Santa C     | 7-17       | 2-4     | 12         |

      # Undo / Move
     When I select "Samstag" from "Wochentag" within the new scheduling form within the modal box body
      And I press "Anlegen"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
        | Mitarbeiter | Donnerstag | Freitag | Samstag | Stunden/WAZ |
        | Santa C     | 7-17       | 2-4     | 5-23    | 30          |
