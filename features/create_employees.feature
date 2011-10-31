Feature: Create Employees
  In order to assign my employees to their shift
  As a planer
  I want to create employees

  Scenario: Create an employee with name
    Given I am signed in as planer
     When I follow "Mitarbeiter"
      And I follow "Hinzufügen"
      And I fill in the following:
        | Vorname  | Homer   |
        | Nachname | Simpson |
      And I press "Hinzufügen"
     Then I should see message "Mitarbeiter erfolgreich angelegt."
      And I should see a list of the following employees:
        | full_name     |
        | Homer Simpson |


  Scenario: Can only see employees of own organization
    Given a planer "me" exists
      And an organization "nukular" exists with planer: planer "me"
      And an employee exists with organization: organization "nukular", first_name: "Homer"

      And a planer "Burns" exists
      And another organization "Chefs" exists with planer: planer "Burns"
      And an employee exists with organization: organization "Chefs", first_name: "Smithers"

     When I sign in as the planer "me"
      And I follow "Mitarbeiter"
     Then I should see "Homer"
      But I should not see "Smithers"

