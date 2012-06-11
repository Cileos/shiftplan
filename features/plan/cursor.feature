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
       | Mitarbeiter   | Mo | Di | Mi | Do               | Fr   | Sa | So |
       | Planner Burns |    |    |    |                  |      |    |    |
       | Carl C        |    |    |    |                  |      |    |    |
       | Lenny L       |    |    |    |                  |      |    |    |
       | Homer S       |    |    |    | 7-11 12-18 19-23 | 7-19 |    |    |
     Then the cell "Mo"/"Planner Burns" should be focus

     When I press arrow up
     Then the cell "Mo"/"Homer S" should be focus
     When I press arrow left
     Then the cell "So"/"Homer S" should be focus
     When I press arrow down
     Then the cell "So"/"Planner Burns" should be focus
     When I press arrow right
     Then the cell "Mo"/"Planner Burns" should be focus
     When I press arrow right
     Then the cell "Di"/"Planner Burns" should be focus
     When I press arrow down
     Then the cell "Di"/"Carl C" should be focus
     When I press arrow left
     Then the cell "Mo"/"Carl C" should be focus
     When I press arrow up
     Then the cell "Mo"/"Planner Burns" should be focus

     # navigate vertically through multiple schedulings per cell
     When I press arrow right 3 times
     Then the cell "Do"/"Planner Burns" should be focus
     When I press arrow down 3 times
     Then the cell "Do"/"Homer S" should be focus
      And the scheduling "7-11" should be focus within the cell "Do"/"Homer S"
     When I press arrow down
     Then the cell "Do"/"Homer S" should be focus
      And the scheduling "12-18" should be focus within the cell "Do"/"Homer S"
     When I press arrow down
     Then the cell "Do"/"Homer S" should be focus
      And the scheduling "19-23" should be focus within the cell "Do"/"Homer S"
     When I press arrow up
     Then the cell "Do"/"Homer S" should be focus
      And the scheduling "12-18" should be focus within the cell "Do"/"Homer S"
     When I press arrow down 2 times
     Then the cell "Do"/"Planner Burns" should be focus

     # navigate vertically through single scheduling per cell
     When I press arrow right
      And I press arrow down 3 times
     Then the cell "Fr"/"Homer S" should be focus
      And the scheduling "7-19" should be focus within the cell "Fr"/"Homer S"
     When I press arrow down
     Then the cell "Fr"/"Planner Burns" should be focus

     # navigate horizontally
     When I press arrow right
      And I press arrow down 3 times
      And I press arrow left
     Then the cell "Fr"/"Homer S" should be focus
      And the scheduling "7-19" should be focus within the cell "Fr"/"Homer S"
      And I press arrow left
     Then the cell "Do"/"Homer S" should be focus
      And the scheduling "7-11" should be focus within the cell "Do"/"Homer S"
     When I press arrow down
      And I press arrow left
      And I press arrow right
     # BUG vs FEATURE does not remember last active item
     Then the cell "Do"/"Homer S" should be focus
      And the scheduling "7-11" should be focus within the cell "Do"/"Homer S"


  Scenario: opening the modal window by pressing enter
    When I press return
     And I wait for the modal box to appear
     And I press escape
     And I wait for the modal box to disappear
    Then the cell "Mo"/"Planner Burns" should be focus
    When I press arrow right
    Then the cell "Di"/"Planner Burns" should be focus

  Scenario: opening the modal window by clicking on an empty cell
    When I click on cell "Mi"/"Carl C"
     And I wait for the modal box to appear
     And I press escape
     And I wait for the modal box to disappear
    Then the cell "Mi"/"Carl C" should be focus
    When I press arrow right
    Then the cell "Do"/"Carl C" should be focus

