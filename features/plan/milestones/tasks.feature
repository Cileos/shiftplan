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
      And a task exists with name: "Kill the King", milestone: the milestone, due_at: "2012-12-22"
      And I am on the page for the plan

  @wip
  Scenario: create tasks for milestone
     When I follow "neue Aufgabe"
      And I fill in "Name" with "become famous"
     Then I should not see "become famous" within the milestones list
     # ^^ do not list unsaved tasks

     When I press "Anlegen"
      And I wait for the spinner to disappear
     Then a task should exist with name: "become famous", milestone: the milestone
      # undef dua_at last
      And I should see "become famous" within the second item within the tasks list within the first item within the milestones list

     When I follow "neue Aufgabe"
      And I fill in "Name" with "become rich"
      And I fill in "Fällig am" with "2012-12-31"
      # to close the date picker
      And I press escape in the "Fällig am" field
      And I select "Homer S" from "Verantwortlicher"
      And I fill in "Beschreibung" with "need money"
      And I press "Anlegen"
      And I wait for the spinner to disappear
     Then a task should exist with name: "become rich", milestone: the milestone
      And the task's due_on should be "2012-12-31"
      And the task's description should be "need money"
      And the employee "Homer" should be the task's responsible
      # sort by due_at asc, undef at bottom
      And I should see a list of the following tasks:
        | name          | employee_name | due_on     |
        | Kill the King |               | 2012-12-22 |
        | become rich   | Homer S       | 2012-12-31 |
        | become famous |               |            |
      # descriptions are not listed, only shown in modal box
      But I should not see "need money" within the milestones list


  @wip
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
      And I should see "Kill all INNOCENT humans" within the second item within the tasks list within the first item within the milestones list
      But I should not see "Kill all humans"

  Scenario: Edit a task
     When I follow "Kill the King"
     Then I should see "Aufgabe bearbeiten" within the modal box header
     When I fill in "Name" with "Kill the Queen"
      And I press "Speichern"
      And I wait for the spinner to disappear
     Then I should not see "Kill the King"
      But I should see "Kill the Queen" within the first item within the tasks list within the first item within the milestones list
      And the task's name should be "Kill the Queen"
