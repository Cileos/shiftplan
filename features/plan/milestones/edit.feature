@javascript
Feature: edit Milestones for a plan
    In order to fix typing mistakes or change of goals
    As a planner
    I want to edit te milestones

  Background:
   Given today is 2012-12-18
     And the situation of a nuclear reactor
     And a milestone exists with name: "Global Domination", plan: the plan
     And I am on the page of the plan "clean reactor"
    When I follow "Global Domination"

  Scenario: Edit an existing milestone
    When I fill in "Name" with "World Domination"
     And I press "Speichern"
     #Then I should see flash notice "Meilenstein erfolgreich geändert"
    Then I should see "World Domination" within the milestones list
     But I should not see "Global Domination" within the milestones list
     And a milestone should exist with name: "World Domination"
     And I should not see a field labeled "Name"

  Scenario: Edit and cancel should rollback changes
    When I fill in "Name" with "Kindergarten"
     And I close the modal box
    Then I should see "Global Domination" within the milestones list
     And a milestone should exist with name: "Global Domination"
     But I should not see "Kindergarten" within the milestones list
     And 0 milestones should exist with name: "Kindergarten"


  # TODO revert changes/redisplay form if milestone invalid
  # Currently we directly edit the properties of the milestone, so they change
  # on the whole client. When get the invalid state by the RESTadapter, we
  # cannot rollback the changes and the 'edit' action was already exited.
  @wip
  Scenario: making the milestone invalid
    When I fill in "Name" with ""
     And I press "Speichern"
    Then I should see flash alert "Meilenstein konnte nicht geändert werden"
     And a milestone should exist with name: "Global Domination"
     And I should see "muss ausgefüllt werden"
     And the "Name" field should contain ""
    When I fill "Name" with "World Domination"
     And I press "Speichern"
    Then a milestone should exist with name: "Global Domination"
     And I should not see "muss ausgefüllt werden"
