@javascript
Feature: Edit Account
  In order to correct typos or show my loyality to the new mother company
  As an owner
  I want to edit my account

  Background:
    Given mr burns, owner of the Springfield Nuclear Power Plant exists
      And I am signed in as the user "mr burns"
      And I am on the accounts page
     When I follow "Account bearbeiten"
      And I wait for the modal box to appear

  Scenario: change name
     When I fill in "Accountbezeichnung" with "Power Plant"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should be on the accounts page
      And I should see flash notice "Account erfolgreich geändert."
      And I should see "Power Plant" within the orientation bar
     When I follow "Organisationen" within the navigation
     Then I should see "Power Plant - Sector 7-G" within the navigation


  Scenario: change timezone
     When I select "(GMT-10:00) Hawaii" from "Zeitzone"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should be on the accounts page
      And I should see flash notice "Account erfolgreich geändert."
