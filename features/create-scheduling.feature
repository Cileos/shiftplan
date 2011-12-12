Feature: create a scheduling
  In order for my employees not to miss any of their shifts
  As a planner
  I want to create a scheduling for my employees

  Background:
    Given a planner exists
      And an organization exists with planner: the planner
      And the organization has the following employees:
        | first_name | last_name |
        | Homer      | S         |
        | Lenny      | L         |
        | Carl       | C         |
      And a plan exists with organization: the organization, first_day: "2011-02-01"
      And I am signed in as the planner
      And I am on the page of the plan


  Scenario: just entering time span
     When I follow "Neue Terminierung"
      And I select "Homer S" from "Mitarbeiter"
      And I select "11" from "Tag"
      And I fill in "Quickie" with "9-17"
      And I press "Anlegen"
     Then I should be on the page of the plan
      And I should see the following calendar:
        | Mitarbeiter | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11   | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 | 25 | 26 | 27 | 28 |
        | Carl C      |   |   |   |   |   |   |   |   |   |    |      |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
        | Lenny L     |   |   |   |   |   |   |   |   |   |    |      |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
        | Homer S     |   |   |   |   |   |   |   |   |   |    | 9-17 |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |


  @javascript
  Scenario: just entering time span with javascript
     When I click on cell "11"/"Homer S"
      And I wait for the new scheduling form to appear
      And I fill in "Quickie" with "9-17"
      And I press "Anlegen"
     Then I should be on the page of the plan
      And I should see the following calendar:
        | Mitarbeiter | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11   | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 | 25 | 26 | 27 | 28 |
        | Carl C      |   |   |   |   |   |   |   |   |   |    |      |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
        | Lenny L     |   |   |   |   |   |   |   |   |   |    |      |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
        | Homer S     |   |   |   |   |   |   |   |   |   |    | 9-17 |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |

  @javascript
  Scenario: navigating through the plan with keystrokes
    Then the cell "1"/"Carl C" should be active
    When I press arrow up
    Then the cell "1"/"Homer S" should be active
    When I press arrow left
    Then the cell "28"/"Homer S" should be active
    When I press arrow down
    Then the cell "28"/"Carl C" should be active
    When I press arrow right
    Then the cell "1"/"Carl C" should be active
    When I press arrow right
    Then the cell "2"/"Carl C" should be active
    When I press arrow down
    Then the cell "2"/"Lenny L" should be active
    When I press arrow left
    Then the cell "1"/"Lenny L" should be active
    When I press arrow up
    Then the cell "1"/"Carl C" should be active

