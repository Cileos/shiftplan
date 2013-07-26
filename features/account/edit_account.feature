Feature: Edit Account
  In order to correct typos or show my loyality to the new mother company
  As an owner
  I want to edit my account

  Scenario: change name
    Given mr burns, owner of the Springfield Nuclear Power Plant exists
      And I am signed in as the user "mr burns"
      And I am on the accounts page
     When I follow "Account bearbeiten"
      And I fill in "Accountbezeichnung" with "Power Plant"
      And I press "Speichern"
     Then I should be on the accounts page
      And I should see "Power Plant - Sector 7-G" within the navigation
