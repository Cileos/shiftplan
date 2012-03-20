@javascript
Feature: Plan cursor
  In order to never touch the mouse
  As a planner with an affection for the keyboard
  I want to navigate the calendar just by keyboard presses

  Background:
    Given the situation of a nuclear reactor
      And I wait for the calendar to appear

  Scenario: navigating through the plan with keystrokes
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

  Scenario: opening the modal window by pressing enter
    When I press return
     And I wait for the modal box to appear
     And I press escape
     And I wait for the modal box to disappear
    Then the cell "Montag"/"Planner Burns" should be focus
    When I press arrow right
    Then the cell "Dienstag"/"Planner Burns" should be focus

  Scenario: opening the modal window by clicking on a ell
    When I click on cell "Mittwoch"/"Carl C"
     And I wait for the modal box to appear
     And I press escape
     And I wait for the modal box to disappear
    Then the cell "Mittwoch"/"Carl C" should be focus
    When I press arrow right
    Then the cell "Donnerstag"/"Carl C" should be focus

