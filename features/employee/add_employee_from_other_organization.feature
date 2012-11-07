Feature: Add Employees from other Organization
  As a planner
  I want to add existing employees of different organizations
  In order to be able to schedule an employee in several organizations

  Background:
    Given the situation of a just registered user
      And a plan "kühlungsraum" exists with name: "Kühlungsraum säubern", organization: the organization "fukushima"

      # employee of a different organization of same account
      And an organization "tschernobyl" exists with name: "Tschernobyl", account: the account "tepco"
      And an employee "homer" exists with first_name: "Homer", last_name: "Simpson", account: the account "tepco"
      And a membership exists with employee: the employee "homer", organization: the organization "tschernobyl"

      # employee of a different organization of same account
      And an organization "krümmel" exists with name: "Krümmel", account: the account "tepco"
      And an employee "bart" exists with first_name: "Bart", last_name: "Simpson", account: the account "tepco"
      And a membership exists with employee: the employee "bart", organization: the organization "krümmel"

      # organization, employee and plan for other account
      And an account "cileos" exists with name: "Cileos UG"
      And an organization "clockwork" exists with account: the account "cileos"
      And an employee "raphaela" exists with first_name: "Raphaela", last_name: "Wrede", account: the account "cileos"
      And a membership exists with employee: the employee "raphaela", organization: the organization "clockwork"
      And a plan exists with name: "Programmieren", organization: the organization "clockwork"

     When I sign in as the confirmed user
      And I am on the employees page for the organization "fukushima"

  Scenario: Adding an employee of a different organization
    Given I should see the following table of employees:
      | Name | WAZ | E-Mail | Status |
     When I follow "Hinzufügen"
     Then I should be on the new employee page for the organization "fukushima"
      And I should see "Owner Burns" within the add members form
      And I should see "Homer Simpson" within the add members form
      And I should see "Bart Simpson" within the add members form
      But I should not see "Raphaela Wrede" within the add members form

     When I check "Owner Burns"
      And I check "Homer Simpson"
      And I press "Mitarbeiter hinzufügen"

     Then I should be on the employees page for the organization "fukushima"
      And I should see flash notice "Mitarbeiter erfolgreich hinzugefügt."
      And I should see the following table of employees:
        | Name           | WAZ | E-Mail          | Status                |
        | Burns, Owner   |     | owner@burns.com | Aktiv                 |
        | Simpson, Homer |     |                 | Noch nicht eingeladen |

     When I follow "Hinzufügen"
     Then I should see "Bart Simpson" within the add members form
      But I should not see "Owner Burns" within the add members form
      And I should not see "Homer Simpson" within the add members form
      And I should not see "Raphaela Wrede" within the add members form

     When I go to the page of the plan "kühlungsraum"
     Then I should see the following calendar:
        | Mitarbeiter   | Mo  | Di  | Mi  | Do  | Fr  | Sa  | So  |
        | Owner Burns   |     |     |     |     |     |     |     |
        | Homer Simpson |     |     |     |     |     |     |     |

  @javascript
  Scenario: Filter employees of other organization while filling in the new employee form
    Given I follow "Hinzufügen"
     Then I should see "Owner Burns" within the add members form
      And I should see "Homer Simpson" within the add members form
      And I should see "Bart Simpson" within the add members form

      And I fill in "Vorname" with "Homer"
     Then I should see "Homer Simpson" within the add members form
      But I should not see "Owner Burns" within the add members form
      And I should not see "Bart Simpson" within the add members form
