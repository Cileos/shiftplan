Feature: Create Employees
  In order to assign my employees to their shift
  As a planner
  I want to manage employees

  Scenario: Creating an employee
    Given I am signed in as planner
     When I follow "Mitarbeiter"
      And I follow "Mitarbeiter hinzufügen"
      And I fill in the following:
        | Vorname           | Homer   |
        | Nachname          | Simpson |
        | Wochenarbeitszeit | 30.5    |
      And I press "Mitarbeiter erstellen"
     Then I should see flash info "Mitarbeiter erfolgreich angelegt."
      And I should be on the employees page
      And I should see "Homer"
      And I should see "30,5"

  Scenario: Visiting the details page of an employee
    Given a planner "me" exists
      And an organization "nukular" exists with planner: planner "me"
      And an employee exists with organization: organization "nukular", first_name: "Homer", weekly_working_time: "38.5"
     When I sign in as the planner "me"
     When I follow "Mitarbeiter"
     When I follow "Homer"
     Then I should be on the page for the employee
     Then I should see "Homer Simpson"
      And I should see "38,5"
     When I follow "Zurück"
     Then I should be on the employees page

  Scenario: Editing an employee
    Given a planner "me" exists
      And an organization "nukular" exists with planner: planner "me"
      And an employee exists with organization: organization "nukular", first_name: "Homer"
     When I sign in as the planner "me"
     When I follow "Mitarbeiter"
     Then I should not see "Biene"
     When I follow "Bearbeiten"
      And I fill in the following:
        | Vorname | Biene |
        | Nachname| Maja  |
     And I press "Mitarbeiter aktualisieren"
    Then I should see "Mitarbeiter erfolgreich geändert."
     And I should be on the employees page
     And I should see "Biene"

  Scenario: Deleting an employee
    Given a planner "me" exists
      And an organization "nukular" exists with planner: planner "me"
      And an employee exists with organization: organization "nukular", first_name: "Homer"
     When I sign in as the planner "me"
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

