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
        | Name            | WAZ  | E-Mail  | Status                 |
        | Simpson, Homer  | 40   |         | Noch nicht eingeladen  |

  Scenario: Editing an employee
    Given I follow "Simpson, Homer" within the employees table
      And I wait for the modal box to appear
      And I fill in the following:
        | Nachname | Simpson-Carlson |
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see flash notice "Mitarbeiter erfolgreich geändert."
      And I should be on the employees page for the organization
      And I should see the following table of employees:
        | Name                    |
        | Simpson-Carlson, Homer  |

  # Planners and owners should not be able to update their own role. We only test this
  # for owners here because specs exist for both planners and owners.
  Scenario: Owner can not update his own role
    # add owner mr. burns to organization
    Given a membership exists with organization: the organization, employee: the employee "mr. burns"
     When I go to the employees page for the organization
      And I follow "Burns, Owner"
      And I wait for the modal box to appear
     Then I should not see a field labeled "Rolle"

  Scenario: Normal user can not edit himself on the employees page
    Given a confirmed user "bart" exists
      And an employee "bart" exists with first_name: "Bart", last_name: "Simpson", account: the account, user: the user "bart"
      And a membership exists with organization: the organization, employee: the employee "bart"

     When I sign in as the confirmed user "bart"
      And I go to the employees page for the organization
     Then I should see the following table of employees:
        | Name            |
        | Simpson, Bart   |
        | Simpson, Homer  |
      And I should not see link "Simpson, Bart" within the employees table
      And I should not see link "Simpson, Homer" within the employees table

  @javascript
  Scenario: removing WAZ from an employee
    Given I follow "Simpson, Homer" within the employees table
      And I wait for the modal box to appear
      And I fill in "Wochenarbeitszeit" with ""
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see the following table of employees:
        | Name            | WAZ  | E-Mail  | Status                 |
        | Simpson, Homer  |      |         | Noch nicht eingeladen  |

     When I inject style "position:relative" into "header"
      And I follow "Simpson, Homer" within the employees table
      And I wait for the modal box to appear
     Then the "Wochenarbeitszeit" field should be empty
