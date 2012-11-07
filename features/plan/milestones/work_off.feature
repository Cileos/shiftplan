@javascript
@big_screen
Feature: working off milestones
  In order to show the progress my organization makes towards a milestone
  As a planner
  I want to track the progress of milestones

  Background:
    Given today is 2012-12-18
      And the situation of a nuclear reactor
      And a milestone exists with name: "World Domination", plan: the plan
      #And a task exists with name: "1 Million", milestone: the milestone
      And I am on the page for the plan

  Scenario: marking a milestone as done
     When I check "done" within the first item within the milestones list
      And I wait for the spinner to disappear
     Then the milestone should be done

  Scenario: deleting a milestone
     When I follow "World Domination"
      And I press "Löschen"
      And I wait for the spinner to disappear
      # And I confirm
      #Then I should see flash notice "Meilenstein erfolgreich gelöscht"
     Then 0 milestones should exist
      And I should not see "World Domination"

