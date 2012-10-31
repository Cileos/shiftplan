@wip
@javascript
@big_screen
Feature: create Milestones for a plan
  In order to achieve the goal of the plan
  As a planner
  I want to create milestones for a plan, containing a list of tasks

  Background:
   Given today is 2012-12-18
     And the situation of a nuclear reactor
     And I follow "neuer Meilenstein"

  Scenario: create a milestone with name only
    When I fill in "Name" with "World domination"
    Then no modal box should be open
    When I press "Anlegen"
     And I wait for the spinner to disappear
    Then I should see "World domination" within the milestones list
     And a milestone should exist with name: "World domination", plan: the plan
     And I should not see a field labeled "Name"

  Scenario: create a milestone with name and due date
    When I fill in "Name" with "World domination"
     And I fill in "Fällig am" with "2012-12-31"
     # to close the date picker
     And I press escape in the "Fällig am" field
     And I press "Anlegen"
     And I wait for the spinner to disappear
    Then a milestone should exist with name: "World domination", plan: the plan
     And the milestone's due_on should be "2012-12-31"

  Scenario: trying to create a milestone without a name adds it to the list, but does not save it
   Given I should not see "muss ausgefüllt werden"
    When I press "Anlegen"
     And I wait for the spinner to disappear
    Then 0 milestones should exist
     And I should see flash alert "Meilenstein konnte nicht angelegt werden."
     And I should see "muss ausgefüllt werden"
     # error messages are shown inline
     And I should not see a field labeled "Name"

