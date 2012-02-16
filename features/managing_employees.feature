Feature: Create Employees
  In order to assign my employees to their shift
  As a planner
  I want to manage employees

  Scenario: Creating an employee
    Given I am signed in as planner
     When I follow "Mitarbeiter"
      And I follow "Mitarbeiter hinzufügen"
      And I fill in the following:
        | Vorname  | Homer   |
        | Nachname | Simpson |
      And I press "Mitarbeiter erstellen"
     Then I should see message "Mitarbeiter erfolgreich angelegt."
      And I should see "Homer"

  Scenario: Visiting the details page of an employee
    Given I am signed in as planner
      And an employee exists with first_name: "Homer", last_name: "Simpson"
     When I follow "Mitarbeiter"
     When I follow "Homer"
     Then I should be on the page for the employee
     Then I should see "Homer Simpson"
     When I follow "Zurück"
     Then I should be on the employees page

  Scenario: Editing an employee
    Given I am signed in as planner
      And an employee exists with first_name: "Homer", last_name: "Simpson"
    When I follow "Mitarbeiter"
     When I follow "Bearbeiten"
      And I fill in the following:
        | Vorname | Biene |
        | Nachname| Maja  |
     And I press "Mitarbeiter aktualisieren"
    Then I should see "Mitarbeiter erfolgreich geändert."
     And I should be on the page for the employee
     And I should see "Biene Maja"

  Scenario: Deleting an employee
    Given I am signed in as planner
      And an employee exists with first_name: "Homer", last_name: "Simpson"
     When I follow "Mitarbeiter"
     Then I should see "Homer"
     When I follow "Löschen"
     Then I should be on the employees page
      And I should not see "Homer"

  Scenario: Can only see employees of own organization
    Given a planner "me" exists
      And an organization "nukular" exists with planner: planner "me"
      And an employee exists with organization: organization "nukular", first_name: "Homer"

      And a planner "Burns" exists
      And another organization "Chefs" exists with planner: planner "Burns"
      And an employee exists with organization: organization "Chefs", first_name: "Smithers"

     When I sign in as the planner "me"
      And I follow "Mitarbeiter"
     Then I should see "Homer"
      But I should not see "Smithers"

