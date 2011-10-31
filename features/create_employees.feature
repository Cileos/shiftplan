Feature: Create Employees
  In order to assign my employees to their shift
  As a manager
  I want to create employees

  Scenario: Create an employee with name
    Given I am signed in as manager
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
