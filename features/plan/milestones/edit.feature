@javascript
Feature: edit Milestones for a plan
    In order to fix typing mistakes or change of goals
    As a planner
    I want to edit te milestones

  Background:
   Given today is 2012-12-18
     And the situation of a nuclear reactor

  Scenario: Edit an existing milestone
   Given a milestone exists with name: "Global Domination", plan: the plan
     And I am on the page of the plan "clean reactor"
     And I follow "Meilensteine"
    When I follow "Bearbeiten" within the first item within the milestones list
     And I fill in "Name" with "World Domination"
     And I press "Speichern"
    Then I should see flash notice "Meilenstein erfolgreich geändert"
     And I should see "World Domination" within the milestones list
     And a milestone should exist with name: "World Domination"
     And I should not see a field labeled "Name"


  Scenario: Edit and create a milestone failed to create
    When I follow "Meilensteine"
     And I follow "neuer Meilenstein"
     And I press "Anlegen"
    Then I should see "muss ausgefüllt werden"
    When I follow "Bearbeiten" within the first item within the milestones list
     And I fill in "Name" with "World Domination"
     And I press "Speichern"
    Then I should see flash notice "Meilenstein erfolgreich angelegt"
     And I should see "World Domination" within the milestones list
     And a milestone should exist with name: "World Domination"
     And I should not see a field labeled "Name"
     And I should not see "muss ausgefüllt werden"


  # TODO revert changes/redisplay form if milestone invalid
  # Currently we directly edit the properties of the milestone, so they change
  # on the whole client. When get the invalid state by the RESTadapter, we
  # cannot rollback the changes and the 'edit' action was already exited.
  Scenario: making the milestone invalid
   Given a milestone exists with name: "World Domination", plan: the plan
     And I am on the page of the plan "clean reactor"
     And I follow "Meilensteine"
    When I follow "Bearbeiten" within the first item within the milestones list
     And I fill in "Name" with ""
     And I press "Speichern"
    Then I should see flash alert "Meilenstein konnte nicht geändert werden"
     And a milestone should exist with name: "World Domination"
     And I should not see a field labeled "Name"
     And I should not see "muss ausgefüllt werden"
