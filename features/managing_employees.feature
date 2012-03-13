Feature: Create Employees
  In order to assign my employees to their shift
  As a planner
  I want to manage employees

  Background:
    Given a planner exists
      And an organization exists with planner: the planner
      And an employee exists with organization: the organization, first_name: "Homer", last_name: "Simpson"
     When I sign in as the planner

  Scenario: Creating an employee
     When I follow "Mitarbeiter"
      And I follow "Mitarbeiter hinzufügen"
      And I fill in the following:
        | Vorname           | Carl    |
        | Nachname          | Carlson |
        | Wochenarbeitszeit | 30.5    |
      And I press "Mitarbeiter erstellen"
     Then I should see flash info "Mitarbeiter erfolgreich angelegt."
      And I should be on the employees page
      # TODO: use table step
      And I should see "Carl Carlson"
      And I should see "30,5"

  Scenario: Editing an employee
     When I follow "Mitarbeiter"
     And I should be on the employees page
     Then I should not see "Carl Carlson"
     When I follow "Homer Simpson"
      And I fill in the following:
        | Vorname  | Carl    |
        | Nachname | Carlson |
     And I press "Mitarbeiter aktualisieren"
    Then I should see "Mitarbeiter erfolgreich geändert."
     And I should be on the employees page
     And I should see "Carl Carlson"
     But I should not see "Homer Simpson"

  Scenario: Deleting an employee
     When I follow "Mitarbeiter"
     Then I should see "Homer Simpson"
     When I follow "Löschen"
     Then I should be on the employees page
      And I should not see "Homer"

  Scenario: Can only see employees of own organization
      And a planner "Burns" exists
      And another organization "Chefs" exists with planner: planner "Burns"
      And an employee exists with organization: organization "Chefs", first_name: "Smithers"

      And I follow "Mitarbeiter"
     Then I should see "Homer Simpson"
      But I should not see "Smithers"

