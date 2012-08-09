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
        | Planner Burns |    |    |      |    |    |    |    |
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
        | Planner Burns |    |    |            |    |    |    |    |
        | Carl C        |    |    |            |    |    |    |    |
        | Lenny L       |    |    |            |    |    |    |    |
        | Homer S       |    |    | 9-17 18-23 |    |    |    |    |


  # TODO: currently it is assumend that a user can only have one organization
  @javascript
  Scenario: can only select employees from same planner (and organization)
    Given an organization "Jungle" exists
      And an employee exists with first_name: "Tarzan", organization: organization "Jungle"
    #  And an organization "Home" exists with planner: the planner
    #  And an employee exists with first_name: "Bart", organization: organization "Home"
     When I go to the page of the plan "clean reactor"
     Then I should see "Homer S"
      And I should not see "Tarzan" within the calendar
     When I follow "Neue Terminierung"
      And I wait for the new scheduling form to appear
     Then I should not see "Tarzan" within the first form

  # TODO: currently it is assumend that a user can only have one organization
  @javascript
  Scenario: can only select employees from same planner (and organization)
    Given an organization "Jungle" exists
      And an employee exists with first_name: "Tarzan", organization: organization "Jungle"
    #  And an organization "Home" exists with planner: the planner
    #  And an employee exists with first_name: "Bart", organization: organization "Home"
     When I go to the page of the plan "clean reactor"
     When I follow "Neue Terminierung"
     #  But I should not see "Bart"
      But I should not see "Tarzan" within the first form
      And I should not see "Tarzan" within the calendar


  @javascript
  Scenario: just entering time span with javascript
     When I schedule "Homer S" on "Do" for "8-18"
     Then I should see the following calendar:
        | Mitarbeiter   | Mo | Di | Mi | Do   | Fr | Sa | So |
        | Planner Burns |    |    |    |      |    |    |    |
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
    Given I wait for the cursor to appear
     Then the cell "Mo"/"Planner Burns" should be focus
     When I press return
      And I wait for the new scheduling form to appear
      And I fill in "Quickie" with "8-18"
      And I press "Anlegen"
      And I wait for the new scheduling form to disappear
     Then I should see the following calendar:
        | Mitarbeiter   | Mo   | Di | Mi | Do | Fr | Sa | So |
        | Planner Burns | 8-18 |    |    |    |    |    |    |
        | Carl C        |      |    |    |    |    |    |    |
        | Lenny L       |      |    |    |    |    |    |    |
        | Homer S       |      |    |    |    |    |    |    |
      And the cell "Mo"/"Planner Burns" should be focus

    # navigate to another cell and press enter again
     When I press arrow down
      And I press arrow right
     Then the cell "Di"/"Carl C" should be focus
     When I press key "n"
      And I wait for the new scheduling form to appear
      And I fill in "Quickie" with "7-17"
      And I press "Anlegen"
      And I wait for the new scheduling form to disappear
     Then I should see the following calendar:
        | Mitarbeiter   | Mo   | Di   | Mi | Do | Fr | Sa | So |
        | Planner Burns | 8-18 |      |    |    |    |    |    |
        | Carl C        |      | 7-17 |    |    |    |    |    |
        | Lenny L       |      |      |    |    |    |    |    |
        | Homer S       |      |      |    |    |    |    |    |
      And the cell "Di"/"Carl C" should be focus

      # navigate further and use the typeahead
     When I press arrow down
      And I press arrow right
     Then the cell "Mi"/"Lenny L" should be focus
     When I press key "a"
      And I wait for the new scheduling form to appear
      And I fill in "Quickie" with "7"
      And I press return in the "Quickie" field
     Then the "Quickie" field should contain "7-17"
     When I press enter in the "Quickie" field
      And I wait for the new scheduling form to disappear
     Then I should see the following calendar:
        | Mitarbeiter   | Mo   | Di   | Mi   | Do | Fr | Sa | So |
        | Planner Burns | 8-18 |      |      |    |    |    |    |
        | Carl C        |      | 7-17 |      |    |    |    |    |
        | Lenny L       |      |      | 7-17 |    |    |    |    |
        | Homer S       |      |      |      |    |    |    |    |
      And the scheduling "7-17" should be focus within the cell "Mi"/"Lenny L"

     When I press arrow right
      And I press arrow left
      And I press key "n"
      And I fill in "Quickie" with "1-3"
     When I press enter in the "Quickie" field
      And I wait for the new scheduling form to disappear
     Then I should see the following calendar:
        | Mitarbeiter   | Mo   | Di   | Mi       | Do | Fr | Sa | So |
        | Planner Burns | 8-18 |      |          |    |    |    |    |
        | Carl C        |      | 7-17 |          |    |    |    |    |
        | Lenny L       |      |      | 1-3 7-17 |    |    |    |    |
        | Homer S       |      |      |          |    |    |    |    |
      And the cell "Mi"/"Lenny L" should be focus
