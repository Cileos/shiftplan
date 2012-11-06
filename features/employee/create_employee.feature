Feature: Create Employees
  In order to assign my employees to their shift
  As a planner
  I want to manage employees

  Background:
    Given the situation of a just registered user
      And a plan exists with name: "Kühlungsraum säubern", organization: the organization
     When I sign in as the confirmed user
      And I am on the employees page for the organization

  @fileupload
  Scenario: Creating an employee
    Given I should see the following table of employees:
      | Name | WAZ | E-Mail | Status |
     When I follow "Hinzufügen"
     Then I should be on the new employee page for the organization
      And the "Wochenarbeitszeit" field should contain "40"
      And I fill in the following:
        | Vorname           | Carl    |
        | Nachname          | Carlson |
        | Wochenarbeitszeit | 30      |
      And I should see a thumb default gravatar within the new employee form
      And I attach the file "app/assets/images/rails.png" to "employee_avatar"
      And I press "Speichern"

     Then I should be on the employees page for the organization
      And I should see flash notice "Mitarbeiter erfolgreich angelegt."
      Then I should see the following table of employees:
        | Name           | WAZ  | E-Mail  | Status                 |
        | Carlson, Carl  | 30   |         | Noch nicht eingeladen  |
     Then I should see the avatar "rails.png" within the row for employee "Carl Carlson"
     When I go to the page of the plan
      And I should see the following calendar:
        | Mitarbeiter   | Mo  | Di  | Mi  | Do  | Fr  | Sa  | So  |
        | Carl Carlson  |     |     |     |     |     |     |     |


  Scenario: Trying to create an employee without a first name
     When I follow "Hinzufügen"
     Then the "Wochenarbeitszeit" field should contain "40"
      And I fill in the following:
        | Nachname          | Carlson |
      And I press "Speichern"
     Then I should see "muss ausgefüllt werden"
      And I should see "Mitarbeiter konnte nicht angelegt werden."

  Scenario: Trying to create an employee without a last name
     When I follow "Hinzufügen"
     Then the "Wochenarbeitszeit" field should contain "40"
      And I fill in the following:
        | Vorname           | Carl    |
      And I press "Speichern"
     Then I should see "muss ausgefüllt werden"
      And I should see "Mitarbeiter konnte nicht angelegt werden."

  Scenario: Creating an employee without a weekly working time
     When I follow "Hinzufügen"
      And I fill in the following:
        | Vorname           | Carl    |
        | Nachname          | Carlson |
        | Wochenarbeitszeit |         |
      And I press "Speichern"
     Then I should see flash notice "Mitarbeiter erfolgreich angelegt."
      And I should see the following table of employees:
        | Name           | WAZ  | E-Mail  | Status                 |
        | Carlson, Carl  |      |         | Noch nicht eingeladen  |

  Scenario: Can only see employees of current organization
    Given another organization "Chefs" exists with account: the account
      And an employee "homer" exists with first_name: "Homer", last_name: "Simpson", account: the account
      And a membership exists with organization: the organization "Chefs", employee: the employee "homer"
      And I am on the employees page for the organization "fukushima"
     Then I should see the following table of employees:
        | Name |

     When I go to the employees page for the organization "Chefs"
     Then I should see the following table of employees:
        | Name            |
        | Simpson, Homer  |
