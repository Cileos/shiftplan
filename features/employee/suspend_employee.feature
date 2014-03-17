@javascript
Feature: Suspend employee
  In order to only see a subset of my employees
  As a planner
  I want to suspend and reinstate memberships of my employees

  Background:
    Given mr burns, owner of the Springfield Nuclear Power Plant exists
     When I am signed in as the user "mr burns"
      And an employee "homer" exists with first_name: "Homer", last_name: "Simpson", account: the account, weekly_working_time: 40, shortcut: "HS"
      And a membership exists with organization: the organization, employee: the employee "homer"
      And I am on the employees page for the organization


  Scenario: Suspending an employee
    Given I should see the following table of employees:
        | Name           | Status                | planbar |
        | Burns, Charles | Aktiv                 | ja      |
        | Simpson, Homer | Noch nicht eingeladen | ja      |
     When I follow "Simpson, Homer" within the employees table
      And I wait for the modal box to appear
     Then the "planbar" checkbox should be checked
     When I uncheck "planbar"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see the following table of employees:
        | Name           | Status                | planbar |
        | Burns, Charles | Aktiv                 | ja      |
        | Simpson, Homer | Noch nicht eingeladen | nein    |
