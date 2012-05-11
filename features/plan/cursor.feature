@javascript
Feature: Plan cursor
  In order to never touch the mouse
  As a planner with an affection for the keyboard
  I want to navigate the calendar just by keyboard presses

  Background:
    Given the situation of a nuclear reactor
      And I wait for the calendar to appear

  Scenario: navigating through the plan with keystrokes
    Given today is Monday, the 2012-12-17
      And the employee "Homer" was scheduled in the plan as following:
        | date       | quickie |
        | 2012-12-20 | 7-11    |
        | 2012-12-20 | 12-18   |
        | 2012-12-20 | 19-23   |
        | 2012-12-21 | 7-19    |
      And I am signed in as the confirmed user "Burns"
      And I am on the page for the plan
      And I should see the following calendar:
       | Mitarbeiter   | Montag | Dienstag | Mittwoch | Donnerstag       | Freitag | Samstag | Sonntag |
       | Planner Burns |        |          |          |                  |         |         |         |
       | Carl C        |        |          |          |                  |         |         |         |
       | Lenny L       |        |          |          |                  |         |         |         |
       | Homer S       |        |          |          | 7-11 12-18 19-23 | 7-19    |         |         |
     Then the cell "Montag"/"Planner Burns" should be focus

     When I press arrow up
     Then the cell "Montag"/"Homer S" should be focus
     When I press arrow left
     Then the cell "Sonntag"/"Homer S" should be focus
     When I press arrow down
     Then the cell "Sonntag"/"Planner Burns" should be focus
     When I press arrow right
     Then the cell "Montag"/"Planner Burns" should be focus
     When I press arrow right
     Then the cell "Dienstag"/"Planner Burns" should be focus
     When I press arrow down
     Then the cell "Dienstag"/"Carl C" should be focus
     When I press arrow left
     Then the cell "Montag"/"Carl C" should be focus
     When I press arrow up
     Then the cell "Montag"/"Planner Burns" should be focus

     # navigate vertically through multiple schedulings per cell
     When I press arrow right 3 times
     Then the cell "Donnerstag"/"Planner Burns" should be focus
     When I press arrow down 3 times
     Then the cell "Donnerstag"/"Homer S" should be focus
      And the scheduling "7-11" should be focus within the cell "Donnerstag"/"Homer S"
     When I press arrow down
     Then the cell "Donnerstag"/"Homer S" should be focus
      And the scheduling "12-18" should be focus within the cell "Donnerstag"/"Homer S"
     When I press arrow down
     Then the cell "Donnerstag"/"Homer S" should be focus
      And the scheduling "19-23" should be focus within the cell "Donnerstag"/"Homer S"
     When I press arrow up
     Then the cell "Donnerstag"/"Homer S" should be focus
      And the scheduling "12-18" should be focus within the cell "Donnerstag"/"Homer S"
     When I press arrow down 2 times
     Then the cell "Donnerstag"/"Planner Burns" should be focus

     # navigate vertically through single scheduling per cell
     When I press arrow right
      And I press arrow down 3 times
     Then the cell "Freitag"/"Homer S" should be focus
      And the scheduling "7-19" should be focus within the cell "Freitag"/"Homer S"
     When I press arrow down
     Then the cell "Freitag"/"Planner Burns" should be focus

  Scenario: opening the modal window by pressing enter
    When I press return
     And I wait for the modal box to appear
     And I press escape
     And I wait for the modal box to disappear
    Then the cell "Montag"/"Planner Burns" should be focus
    When I press arrow right
    Then the cell "Dienstag"/"Planner Burns" should be focus

  Scenario: opening the modal window by clicking on an empty cell
    When I click on cell "Mittwoch"/"Carl C"
     And I wait for the modal box to appear
     And I press escape
     And I wait for the modal box to disappear
    Then the cell "Mittwoch"/"Carl C" should be focus
    When I press arrow right
    Then the cell "Donnerstag"/"Carl C" should be focus

