@javascript
Feature: Plan cursor
  In order to never touch the mouse
  As a planner with an affection for the keyboard
  I want to navigate the calendar just by keyboard presses

  Background:
    Given the situation of a nuclear reactor

  Scenario: navigating through the plan with keystrokes
    Given I am on the page for the plan
      And I wait for the calendar to appear
     Then the cell "Montag"/"Carl C" should be focus
     When I press arrow up
     Then the cell "Montag"/"Homer S" should be focus
     When I press arrow left
     Then the cell "Sonntag"/"Homer S" should be focus
     When I press arrow down
     Then the cell "Sonntag"/"Carl C" should be focus
     When I press arrow right
    Then the cell "Montag"/"Carl C" should be focus
    When I press arrow right
    Then the cell "Dienstag"/"Carl C" should be focus
    When I press arrow down
    Then the cell "Dienstag"/"Lenny L" should be focus
    When I press arrow left
    Then the cell "Montag"/"Lenny L" should be focus
    When I press arrow up
    Then the cell "Montag"/"Carl C" should be focus

