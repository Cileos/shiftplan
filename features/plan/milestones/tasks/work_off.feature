@javascript
Feature: Work of task for milestone of a plan
  In order to see the progress towards the goal of a milestone
  As a planner
  I want to mark tasks as done

  Background:
    Given today is 2012-12-18
      And the situation of a nuclear reactor
      And a milestone exists with name: "World Domination", plan: the plan
      And a task exists with name: "Kill the King", milestone: the milestone

  Scenario: mark task for milestone as done
    Given I am on the page for the plan
     When I check the task "Kill the King"
      And I wait for the spinner to disappear
     Then the task should be done

     When I uncheck the task "Kill the King"
      And I wait for the spinner to disappear
     Then the task should not be done

  Scenario: can mark milestone only if all tasks are marked
    Given a task exists with name: "Kill the Queen", milestone: the milestone
      And I am on the page for the plan
      And the "done" milestone checkbox should be disabled within the milestones list

     When I check the task "Kill the Queen"
     Then the "done" milestone checkbox should be disabled

     When I check the task "Kill the King"
     Then the "done" milestone checkbox should not be disabled
