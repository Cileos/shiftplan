Feature: Create Employees
  In order to assign my employees to their shift
  As a planner
  I want to manage employees

  Background:
    Given mr burns, owner of the Springfield Nuclear Power Plant exists
      And a plan exists with name: "Kühlungsraum säubern", organization: the organization
      And I am signed in as the user "mr burns"
      And I am on the employees page for the organization
     Then I should see the following table of employees:
       | Name            | WAZ  | E-Mail                       | Status  |
       | Burns, Charles  |      | c.burns@npp-springfield.com  | Aktiv   |

  @fileupload
  Scenario: Creating an employee
    Given I follow "Hinzufügen"
     Then I should be on the new employee page for the organization
      And the "Wochenarbeitszeit" field should contain "40"
     When I fill in the following:
        | Vorname           | Carl    |
        | Nachname          | Carlson |
        | Wochenarbeitszeit | 30      |
        | Kürzel            | Cc      |
      And I should see a thumb default gravatar within the new employee form
      And I attach the file "app/assets/images/rails.png" to "employee_avatar"
      And I press "Anlegen"

     Then I should be on the employees page for the organization
      And I should see flash notice "Mitarbeiter erfolgreich angelegt."
      Then I should see the following table of employees:
        | Name           | Kürzel | WAZ | E-Mail                      | Status                |
        | Burns, Charles | CB     |     | c.burns@npp-springfield.com | Aktiv                 |
        | Carlson, Carl  | Cc     | 30  |                             | Noch nicht eingeladen |
     Then I should see the avatar "rails.png" within the row for employee "Carl Carlson"
     When I go to the page of the plan

  @javascript
  Scenario: Creating a planner
    Given I follow "Hinzufügen"
      And I fill in the following:
        | Vorname           | Carl    |
        | Nachname          | Carlson |
      And I select "Planer" from "Rolle"
      And I press "Anlegen"
      And I should be on the employees page for the organization
     Then I should see the following table of employees:
       | Name            | WAZ  | E-Mail                       | Rolle           | Status                 |
       | Burns, Charles  |      | c.burns@npp-springfield.com  | Accountinhaber  | Aktiv                  |
       | Carlson, Carl   | 40   |                              | Planer          | Noch nicht eingeladen  |

     When I follow "Carlson, Carl" within the employees table
      And I wait for the modal box to appear
     Then the selected "Rolle" should be "Planer"
      And I select "keine" from "Rolle"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see the following table of employees:
       | Name            | WAZ  | E-Mail                       | Rolle           | Status                 |
       | Burns, Charles  |      | c.burns@npp-springfield.com  | Accountinhaber  | Aktiv                  |
       | Carlson, Carl   | 40   |                              | keine           | Noch nicht eingeladen  |

  Scenario: Creating an employee without a weekly working time
    Given I follow "Hinzufügen"
      And I fill in the following:
        | Vorname           | Carl    |
        | Nachname          | Carlson |
        | Wochenarbeitszeit |         |
      And I press "Anlegen"
     Then I should see flash notice "Mitarbeiter erfolgreich angelegt."
      And I should see the following table of employees:
        | Name            | WAZ  | E-Mail                       | Status                 |
        | Burns, Charles  |      | c.burns@npp-springfield.com  | Aktiv                  |
        | Carlson, Carl   |      |                              | Noch nicht eingeladen  |

  Scenario: Can only see employees of current organization
    Given another organization "Chefs" exists with account: the account
      And an employee "homer" exists with first_name: "Homer", last_name: "Simpson", account: the account
      And a membership exists with organization: the organization "Chefs", employee: the employee "homer"
      And I am on the employees page for the organization "sector 7g"
     Then I should see the following table of employees:
        | Name            | WAZ  | E-Mail                       | Status  |
        | Burns, Charles  |      | c.burns@npp-springfield.com  | Aktiv   |

     When I go to the employees page for the organization "Chefs"
     Then I should see the following table of employees:
        | Name            |
        | Simpson, Homer  |
