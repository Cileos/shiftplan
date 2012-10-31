@wip
@javascript
@big_screen
Feature: Milestones and tasks for a plan
  In order to achieve the goal of the plan
  As a planner
  I want to see milestones for a plan, containing a list of tasks

  Background:
    Given today is 2012-12-18
      And the situation of a nuclear reactor

  Scenario: Listing existing milestones
   Given the following milestones exist:
     | plan     | name             | due_at     |
     | the plan | World Domination | 2012-12-31 |
     | the plan | Rest             |            |
    When I go to the page for the plan
    # TODO date should be formatted
    Then I should see a list of the following milestones:
     | name             | due_on     |
     | World Domination | 2012-12-31 |
     | Rest             |            |

