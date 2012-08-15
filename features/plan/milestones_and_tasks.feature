@javascript
@big_screen
Feature: Milestones and tasks for plan
  In order not to forget anything and tell my employees what to do
  As a planner
  I want to manage milestones and tasks for a plan

  Background:
    Given the situation of a nuclear reactor

  Scenario: create a milestone
    When I follow "neuer Meilenstein"
     And I fill in "Name" with "World domination"
     And I press "Anlegen"
    Then I should see "Word domination" within the milestones list
     And a milestone should exist with name: "Word domination", plan: the plan
