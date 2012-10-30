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
      And a task exists with name: "1 Million", milestone: the milestone
      And I am on the page for the plan
      And I follow "Meilensteine"

  @wip
  Scenario: marking a milestone as done
     When I check "done" within the first item within the milestones list
      And I close the modal box
      And I wait for the modal box to disappear
     Then the milestone should be done

  Scenario: deleting a milestone
     When I follow "World Domination"
      And I press "Löschen"
      # And I confirm
     Then I should see flash notice "Meilenstein erfolgreich gelöscht"
      And 0 milestones should exist
      And I should not see "World Domination"

  @wip
  Scenario: create tasks for milestone
     When I follow "neue Aufgabe"
      And I fill in "Name" with "become rich"
      And I press "Anlegen"
     Then I should see "become rich" within the second item within the tasks list within the first item within the milestones list

     When I follow "neue Aufgabe"
      And I fill in "Name" with "become famous"
      And I press "Anlegen"
     Then I should see "become famous" within the third item within the tasks list within the first item within the milestones list

  @wip
  Scenario: mark task for milestone as done
     When I check "done" within the first item within the tasks list within the first item within the milestones list
      And I close the modal box
      And I wait for the modal box to disappear
     Then the task should be done
