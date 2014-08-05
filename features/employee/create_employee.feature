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


  Scenario: One step creation and invitation of employee
    Given a clear email queue
      And today is "2012-05-24 12:00"
     When I am on the new employee page for the organization
     Then I should not see a field labeled "E-Mail"

     When I fill in the following:
        | Vorname   | Carl              |
        | Nachname  | Carlson           |
      And I check "Sofort einladen"
     Then I should see a field labeled "E-Mail"
     When I fill in "E-Mail" with ""
      And I press "Anlegen"
     Then I should see "muss ausgefüllt werden"
      # E-Mail field should still be visible because "Sofort einladen" was initially checked
      And I should see a field labeled "E-Mail"
     When I fill in "E-Mail" with "carl@carlson.com"
      And I press "Anlegen"
     Then I should see flash notice "Mitarbeiter erfolgreich angelegt."
      And I should see the following table of employees:
       | Name            | E-Mail                       | Status                                 |
       | Burns, Charles  | c.burns@npp-springfield.com  | Aktiv                                  |
       | Carlson, Carl   | carl@carlson.com             | Eingeladen am 24.05.2012 um 12:00 Uhr  |
      And "carl@carlson.com" should receive an email with subject "Sie wurden zu Clockwork eingeladen"
