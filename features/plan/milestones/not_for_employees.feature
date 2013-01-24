@javascript
Feature: Employees may not create/edit milestones
  In order to follow the grand vision of my boss
  As a normal employee
  I don't want to be allowed to change milestones or tasks

  Background:
    Given the situation of a nuclear reactor
      And a milestone exists with name: "World Domination", plan: plan "clean reactor"
      And a task exists with name: "Aquire money", milestone: the milestone
      And I am signed in as the confirmed user "Homer"

  Scenario: Cannot create nor edit milestones nor tasks
     When I go to the page of the plan "clean reactor"
     Then I should see "World Domination"
      And I should see "Aquire money"
      But I should not see "neuer Meilenstein"
      And I should not see "neue Aufgabe"

    # still need modalbox to look at details, can only close it, so eventual changes are reverted
     When I follow "World Domination"
     Then I should not see "Speichern"

     When I close the modal box
      And I follow "Aquire money"
     Then I should not see "Speichern"

