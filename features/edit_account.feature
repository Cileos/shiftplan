Feature:
  As an owner
  I want to edit the name of my account

  Scenario:
    Given the situation of a just registered user
     When I go to the page of the account
      And I follow "Account bearbeiten"
      And I fill in "Name" with "Tepco UG"
      And I press "Speichern"
     Then I should be on the page of the account
      And I should see "Tepco UG" within the navigation

