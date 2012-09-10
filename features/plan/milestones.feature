@javascript
@big_screen
Feature: Milestones and tasks for plan
  In order not to forget anything and tell my employees what to do
  As a planner
  I want to manage milestones and tasks for a plan

  Background:
    Given today is 2012-12-18
    Given the situation of a nuclear reactor

  Scenario: create a milestone with name only
    When I follow "neuer Meilenstein"
     And I fill in "Name" with "World domination"
     And I press "Anlegen"
    Then I should see "World domination" within the milestones list
     And a milestone should exist with name: "World domination", plan: the plan

  Scenario: create a milestone with name and due date
    When I follow "neuer Meilenstein"
     And I fill in "Name" with "World domination"
     And I fill in "Fällig am" with "2012-12-31"
     # to close the date picker
     And I press escape in the "Fällig am" field
     And I press "Anlegen"
     And I wait for the spinner to disappear
    Then a milestone should exist with name: "World domination", plan: the plan
     And the milestone's due_on should be "2012-12-31"

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

  Scenario: marking a milestone as done
    Given a milestone exists with name: "World Domination", plan: the plan
      And I am on the page for the plan
     When I check "done" within the first item within the milestones list
      And I wait for the spinner to disappear
     Then the milestone should be done
