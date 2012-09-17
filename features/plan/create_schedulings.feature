Feature: create a scheduling
  In order for my employees not to miss any of their shifts
  As a planner
  I want to create a scheduling for my employees

  Background:
    Given today is 2012-02-13
      And the situation of a nuclear reactor

  @javascript
  Scenario: just entering time span
     When I follow "Neue Terminierung"
     Then I should see "9-17 wichtige Arbeit [wA]" within a hint
      And I select "Homer S" from "Mitarbeiter"
      And I select "Mittwoch" from "Wochentag"
      And I fill in "Quickie" with "9-17"
      And I press "Anlegen"
     Then I should see the following calendar:
        | Mitarbeiter   | Mo | Di | Mi   | Do | Fr | Sa | So |
        | Carl C        |    |    |      |    |    |    |    |
        | Lenny L       |    |    |      |    |    |    |    |
        | Homer S       |    |    | 9-17 |    |    |    |    |
     And the employee "Homer S" should have a yellow hours/waz value of "8 / 40"

  @javascript
  Scenario: scheduling the same employee twice per day
    Given the employee "Homer" was scheduled in the plan as following:
        | date       | quickie |
        | 2012-02-15 | 9-17    |
      And I am on the page of the plan
     When I follow "Neue Terminierung"
      And I select "Homer S" from "Mitarbeiter"
      And I select "Mittwoch" from "Wochentag"
      And I fill in "Quickie" with "18-23"
      And I press "Anlegen"
     Then I should see the following calendar:
        | Mitarbeiter   | Mo | Di | Mi         | Do | Fr | Sa | So |
        | Carl C        |    |    |            |    |    |    |    |
        | Lenny L       |    |    |            |    |    |    |    |
        | Homer S       |    |    | 9-17 18-23 |    |    |    |    |

  @javascript
  Scenario: can only select employees being member of the current organization
    Given an organization "Jungle" exists with account: the account
      And an employee "tarzan" exists with first_name: "Tarzan", account: the account
      And a membership exists with organization: the organization "Jungle", employee: the employee "tarzan"
     When I go to the page of the plan "clean reactor"
     Then I should see "Homer S"
      And I should not see "Tarzan" within the calendar
     When I follow "Neue Terminierung"
      And I wait for the new scheduling form to appear
     Then I should not see "Tarzan" within the first form

  @javascript
  Scenario: just entering time span with javascript
     When I schedule "Homer S" on "Do" for "8-18"
     Then I should see the following calendar:
        | Mitarbeiter   | Mo | Di | Mi | Do   | Fr | Sa | So |
        | Carl C        |    |    |    |      |    |    |    |
        | Lenny L       |    |    |    |      |    |    |    |
        | Homer S       |    |    |    | 8-18 |    |    |    |

  @javascript
  Scenario: Entering the time span wrong
     When I click on cell "Di"/"Carl C"
      And I wait for the new scheduling form to appear
      And I fill in "Quickie" with "13-"
      And I press "Anlegen"
     Then I should see "Quickie ist nicht gültig" within errors within the new scheduling form

  @javascript
  Scenario: schedule only using the keyboard (Enter, n or a)
     Then the cell "Mo"/"Carl C" should be focus
     When I press return
      And I wait for the new scheduling form to appear
      And I fill in "Quickie" with "8-18"
      And I press "Anlegen"
      And I wait for the new scheduling form to disappear
     Then I should see the following calendar:
        | Mitarbeiter   | Mo   | Di | Mi | Do | Fr | Sa | So |
        | Carl C        | 8-18 |    |    |    |    |    |    |
        | Lenny L       |      |    |    |    |    |    |    |
        | Homer S       |      |    |    |    |    |    |    |
      And the cell "Mo"/"Carl C" should be focus

    # navigate to another cell and press enter again
     When I press arrow down
      And I press arrow right
     Then the cell "Di"/"Lenny L" should be focus
     When I press key "n"
      And I wait for the new scheduling form to appear
      And I fill in "Quickie" with "7-17"
      And I press "Anlegen"
      And I wait for the new scheduling form to disappear
     Then I should see the following calendar:
        | Mitarbeiter   | Mo   | Di   | Mi | Do | Fr | Sa | So |
        | Carl C        | 8-18 |      |    |    |    |    |    |
        | Lenny L       |      | 7-17 |    |    |    |    |    |
        | Homer S       |      |      |    |    |    |    |    |
      And the cell "Di"/"Lenny L" should be focus

      # navigate further and use the typeahead
     When I press arrow down
      And I press arrow right
     Then the cell "Mi"/"Homer S" should be focus
     When I press key "a"
      And I wait for the new scheduling form to appear
      And I fill in "Quickie" with "7"
      And I press return in the "Quickie" field
     Then the "Quickie" field should contain "7-17"
     When I press enter in the "Quickie" field
      And I wait for the new scheduling form to disappear
     Then I should see the following calendar:
        | Mitarbeiter  | Mo    | Di    | Mi    | Do  | Fr  | Sa  | So  |
        | Carl C       | 8-18  |       |       |     |     |     |     |
        | Lenny L      |       | 7-17  |       |     |     |     |     |
        | Homer S      |       |       | 7-17  |     |     |     |     |
      And the scheduling "7-17" should be focus within the cell "Mi"/"Homer S"

     When I press arrow right
      And I press arrow left
      And I press key "n"
      And I fill in "Quickie" with "1-3"
     When I press enter in the "Quickie" field
      And I wait for the new scheduling form to disappear
     Then I should see the following calendar:
        | Mitarbeiter  | Mo    | Di    | Mi        | Do  | Fr  | Sa  | So  |
        | Carl C       | 8-18  |       |           |     |     |     |     |
        | Lenny L      |       | 7-17  |           |     |     |     |     |
        | Homer S      |       |       | 1-3 7-17  |     |     |     |     |
      And the cell "Mi"/"Homer S" should be focus
