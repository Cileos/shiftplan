@javascript
Feature: Create Employees
  In order to assign my employees to their shift
  As a planner
  I want to manage employees

  Background:
    Given mr burns, owner of the Springfield Nuclear Power Plant exists
      And a plan exists with name: "Kühlungsraum säubern", organization: the organization
      And I am signed in as the user "mr burns"
      And I am on the employees page for the organization

  @fileupload
  Scenario: Creating an employee
    Given the following qualifications exist:
      | name    | account     |
      | Koch    | the account |

      And I follow "Hinzufügen"
     Then I should be on the new employee page for the organization
      And the "Wochenarbeitszeit" field should contain "40"
     When I fill in the following:
        | Vorname           | Carl    |
        | Nachname          | Carlson |
        | Wochenarbeitszeit | 30      |
        | Kürzel            | Cc      |
      And I select "Koch" from the "Qualifikationen" multiple-select box
      And I select "Planer" from "Rolle"
      And I attach the file "app/assets/images/rails.png" to "employee_avatar"
      And I press "Anlegen"

     Then I should be on the employees page for the organization
      And I should see flash notice "Mitarbeiter erfolgreich angelegt."
      Then I should see the following table of employees:
        | Name            | Kürzel  | WAZ  | E-Mail                       | Rolle           | Status                 | Qualifikationen  |
        | Burns, Charles  | CB      |      | c.burns@npp-springfield.com  | Accountinhaber  | Aktiv                  | keine            |
        | Carlson, Carl   | Cc      | 30   |                              | Planer          | Noch nicht eingeladen  | Koch             |
     Then I should see the avatar "rails.png" within the row for employee "Carl Carlson"
     When I go to the page of the plan
