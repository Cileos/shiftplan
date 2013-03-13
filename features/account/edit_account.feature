Feature: Edit Account
  In order to correct typos or show my loyality to the new mother company
  As an owner
  I want to edit my account

  Scenario: change name
    Given the situation of a just registered user
     When I go to the page of the account
      And I follow "Account bearbeiten"
      And I fill in "Accountbezeichnung" with "Tepco UG"
      And I press "Speichern"
     Then I should be on the page of the account
      And I should see "Tepco UG" within the navigation

