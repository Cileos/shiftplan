@javascript
Feature: Edit Employee
  As a planner
  I want to edit employees

  Background:
    Given the situation of a just registered user
      And an employee "homer" exists with first_name: "Homer", last_name: "Simpson", account: the account, weekly_working_time: 40
      And a membership exists with organization: the organization, employee: the employee "homer"
     When I sign in as the confirmed user
      And I am on the employees page for the organization
     Then I should see the following table of employees:
        | Name            | WAZ  | E-Mail           | Status                 |
        | Burns, Owner    |      | owner@burns.com  | Aktiv                  |
        | Simpson, Homer  | 40   |                  | Noch nicht eingeladen  |

  Scenario: Editing an employee
     When I follow "Simpson, Homer" within the employees table
      And I wait for the modal box to appear
      And I fill in the following:
        | Nachname | Simpson-Carlson |
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see flash notice "Mitarbeiter erfolgreich geändert."
      And I should be on the employees page for the organization
      And I should see the following table of employees:
        | Name                    |
        | Burns, Owner            |
        | Simpson-Carlson, Homer  |

  # Planners and owners should not be able to update their own role. We only test this
  # for owners here because specs exist for both planners and owners.
  Scenario: Owner can not update his own role
     When I go to the employees page for the organization
      And I follow "Burns, Owner"
      And I wait for the modal box to appear
     Then I should not see a field labeled "Rolle"
     When I manipulate the form "edit_employee" with attribute "employee[role]" and value ""
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see the following table of employees:
        | Name            | Rolle           |
        | Burns, Owner    | Accountinhaber  |
        | Simpson, Homer  | keine           |

  # The role owner can not be assigned to other employees
  Scenario: Trying to promote someone to owner
    Given I follow "Simpson, Homer" within the employees table
      And I wait for the modal box to appear
     When I manipulate the form "edit_employee" with attribute "employee[role]" and value "owner"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see the following table of employees:
        | Name            | Rolle           |
        | Burns, Owner    | Accountinhaber  |
        | Simpson, Homer  | keine           |

  Scenario: Owner can not be updated by any one else
    Given a confirmed user "planner bart" exists with email: "bart@thesimpsons.com"
      And an employee_planner "planner bart" exists with first_name: "Bart", user: the confirmed user "planner bart", account: the account
      And a membership exists with organization: the organization, employee: the employee "planner bart"
      And I am signed in as the confirmed user "planner bart"
     When I go to the employees page for the organization
     Then I should see the following table of employees:
        | Name            | Rolle           |
        | Burns, Owner    | Accountinhaber  |
        | Simpson, Bart   | Planer          |
        | Simpson, Homer  | keine           |
      And I should see link "Simpson, Bart"
      And I should see link "Simpson, Homer"
      But I should not see link "Burns, Owner"

  @javascript
  Scenario: removing WAZ from an employee
    Given I follow "Simpson, Homer" within the employees table
      And I wait for the modal box to appear
      And I fill in "Wochenarbeitszeit" with ""
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see the following table of employees:
        | Name            | WAZ  | E-Mail           | Status                 |
        | Burns, Owner    |      | owner@burns.com  | Aktiv                  |
        | Simpson, Homer  |      |                  | Noch nicht eingeladen  |

     When I follow "Simpson, Homer" within the employees table
      And I wait for the modal box to appear
     Then the "Wochenarbeitszeit" field should be empty
