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
      And I am on the page for the plan

  Scenario: mark task for milestone as done
     When I check "done" within the first item within the tasks list within the first item within the milestones list
      And I wait for the spinner to disappear
     Then the task should be done

     When I uncheck "done" within the first item within the tasks list within the first item within the milestones list
      And I wait for the spinner to disappear
     Then the task should not be done
