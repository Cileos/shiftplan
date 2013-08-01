@javascript
Feature: Edit Account
  In order to correct typos or show my loyality to the new mother company
  As an owner
  I want to edit my account

  Scenario: change name
    Given the situation of a just registered user
      And I am on the accounts page
     When I follow "Account bearbeiten"
      And I wait for the modal box to appear
      And I fill in "Accountbezeichnung" with "Tepco UG"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should be on the accounts page
      And I should see "Tepco UG" within the content
      And I should see "Tepco UG - Fukushima" within the navigation
