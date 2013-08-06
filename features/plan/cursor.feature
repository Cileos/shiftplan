@javascript
Feature: Calendar cursor
  In order to never touch the mouse
  As a planner with an affection for the keyboard
  I want to navigate the calendar just by keyboard presses

  Background:
    Given the situation of a nuclear reactor
      And I wait for the calendar to appear

  Scenario: navigating through the plan with keystrokes
    Given the employee "Homer" was scheduled in the plan as following:
        | date       | quickie |
        | 2012-12-20 | 7-11    |
        | 2012-12-20 | 12-18   |
        | 2012-12-20 | 19-23   |
        | 2012-12-21 | 7-19    |
      And I am signed in as the confirmed user "Burns"
      And I am on the employees in week page for the plan for week: 51, cwyear: 2012
      And I should see the following calendar:
       | Mitarbeiter      | Mo | Di | Mi | Do                                  | Fr          | Sa | So |
       | Planner Burns    |    |    |    |                                     |             |    |    |
       | Carl C           |    |    |    |                                     |             |    |    |
       | Lenny L          |    |    |    |                                     |             |    |    |
       | Homer S          |    |    |    | 07:00-11:00 12:00-18:00 19:00-23:00 | 07:00-19:00 |    |    |
       | Ohne Mitarbeiter |    |    |    |                                     |             |    |    |
      And I assume the calendar will not change
     Then the cell "Mo"/"Planner Burns" should be focus

     # wrap vertically and horizontally
     When I press arrow up 2 times
     Then the cell "Mo"/"Homer S" should be focus
     When I press arrow left
     Then the cell "So"/"Homer S" should be focus
     When I press arrow down 3 times
     Then the cell "So"/"Carl C" should be focus
     When I press arrow right
     Then the cell "Mo"/"Carl C" should be focus
     When I press arrow right
     Then the cell "Di"/"Carl C" should be focus
     When I press arrow down
     Then the cell "Di"/"Lenny L" should be focus
     When I press arrow left
     Then the cell "Mo"/"Lenny L" should be focus
     When I press arrow up
     Then the cell "Mo"/"Carl C" should be focus

     # vim controls
     When I press key "j"
     Then the cell "Mo"/"Lenny L" should be focus
     When I press key "l"
     Then the cell "Di"/"Lenny L" should be focus
     When I press key "k"
     Then the cell "Di"/"Carl C" should be focus
     When I press key "h"
     Then the cell "Mo"/"Carl C" should be focus

     # navigate vertically through multiple schedulings per cell
     When I press arrow right 3 times
     Then the cell "Do"/"Carl C" should be focus
     When I press arrow down 2 times
     Then the cell "Do"/"Homer S" should be focus
     And the scheduling "07:00-11:00" should be focus within the cell "Do"/"Homer S"
     When I press arrow down
     Then the cell "Do"/"Homer S" should be focus
     And the scheduling "12:00-18:00" should be focus within the cell "Do"/"Homer S"
     When I press arrow down
     Then the cell "Do"/"Homer S" should be focus
     And the scheduling "19:00-23:00" should be focus within the cell "Do"/"Homer S"
     When I press arrow up
     Then the cell "Do"/"Homer S" should be focus
     And the scheduling "12:00-18:00" should be focus within the cell "Do"/"Homer S"
     When I press arrow down 4 times
     Then the cell "Do"/"Carl C" should be focus

     # navigate vertically through single scheduling per cell
     When I press arrow right
      And I press arrow down 2 times
     Then the cell "Fr"/"Homer S" should be focus
     And the scheduling "07:00-19:00" should be focus within the cell "Fr"/"Homer S"
     When I press arrow down 3 times
     Then the cell "Fr"/"Carl C" should be focus

     # navigate horizontally
     When I press arrow right
      And I press arrow down 2 times
      And I press arrow left
     Then the cell "Fr"/"Homer S" should be focus
     And the scheduling "07:00-19:00" should be focus within the cell "Fr"/"Homer S"
      And I press arrow left
     Then the cell "Do"/"Homer S" should be focus
     And the scheduling "07:00-11:00" should be focus within the cell "Do"/"Homer S"
     When I press arrow down
      And I press arrow left
      And I press arrow right
     # BUG vs FEATURE does not remember last active item
     Then the cell "Do"/"Homer S" should be focus
     And the scheduling "07:00-11:00" should be focus within the cell "Do"/"Homer S"


  # In reality, the first field in the modal box with be focussed
  # automatically, so it takes 2 presses of ESC to close the modal box - 1 for
  # unfocus, one for close - at least in the current dev version of Chrome
  # (24.0.1305.3) We cannot test this properly as the first ESC is processed by
  # the browser before selenium can take any action.
  Scenario: opening the modal window by pressing enter and closing it by pressing escape
    When I press return
     And I wait for the modal box to appear
     And I press escape
     And I wait for the modal box to disappear
    Then the cell "Mo"/"Planner Burns" should be focus
    When I press arrow right
    Then the cell "Di"/"Planner Burns" should be focus
