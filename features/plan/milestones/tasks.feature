@javascript
@big_screen
Feature: Tasks of milestones
  In order to describe the goals of a milestones in detail
  As a planner
  I want to create, edit and delete tasks

  Background:
    Given today is 2012-12-18
      And the situation of a nuclear reactor
      And a milestone exists with name: "World Domination", plan: the plan
      And I am on the page for the plan

  Scenario: create tasks for milestone
     When I follow "neue Aufgabe"
      And I fill in "Name" with "become famous"
     Then I should not see "become famous" within the milestones list
     # ^^ do not list unsaved tasks

     When I press "Anlegen"
      And I wait for the spinner to disappear
     Then a task should exist with name: "become famous", milestone: the milestone
      And I should see "become famous" within the first item within the tasks list within the first item within the milestones list

     When I follow "neue Aufgabe"
      And I fill in "Name" with "become rich"
      And I press "Anlegen"
      And I wait for the spinner to disappear
     Then a task should exist with name: "become rich", milestone: the milestone
      And I should see "become rich" within the first item within the tasks list within the first item within the milestones list
      And I should see "become famous" within the second item within the tasks list within the first item within the milestones list
      # task seem to be prepended to the list (?!)

  Scenario: start to create, cancel, try again (Bender mode)
     When I follow "neue Aufgabe"
      And I fill in "Name" with "Kill all humans"
      And I close the modal box
     Then I should not see "Kill all humans"
      And 0 tasks should exist with name: "Kill all humans"

     When I follow "neue Aufgabe"
      And I fill in "Name" with "Kill all INNOCENT humans"
      And I press "Anlegen"
      And I wait for the spinner to disappear
     Then a task should exist with name: "Kill all INNOCENT humans", milestone: the milestone
      And I should see "Kill all INNOCENT humans" within the first item within the tasks list within the first item within the milestones list
      But I should not see "Kill all humans"

