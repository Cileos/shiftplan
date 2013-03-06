Feature: create organizations
  As an owner of an account with too much chaos
  In order to optimize my plans
  I want to create another organization belonging to the same account

  Background:
    Given the situation of a just registered user
      And a account "cileos" exists with name: "Cileos UG"
      And an organization "tschernobyl" exists with name: "Tschernobyl", account: the account "tepco"
      And an organization "clockwork programming" exists with name: "Clockwork Programming", account: the account "cileos"
      And an organization "clockwork marketing" exists with name: "Clockwork Marketing", account: the account "cileos"
      And an employee "charles m. burns" exists with first_name: "Charles M.", last_name: "Burns", account: the account "cileos", user: the confirmed user
      And a membership exists with organization: the organization "clockwork programming", employee: the employee "charles m. burns"
      And I go to the dashboard page

  Scenario: Create another organization
    Given I follow "Tepco GmbH" within the navigation
     # user is owner of account "tepco" so he can create new organizations
     When I follow "Organisation hinzufügen"
     Then I should be on the new organization page for the account "tepco"
      And I fill in "Name" with "Another Organization"
      And I press "Anlegen"
     Then I should see notice "Organisation 'Another Organization' angelegt."
      And I should be on the page of the account "tepco"
      And I should see the following table of organizations:
       | Name                  |
       | Fukushima             |
       | Tschernobyl           |
       | Another Organization  |

  Scenario: Normal employee can not create organizations on account page
    Given I follow "Cileos UG" within the navigation
     Then I should be on the page of the account "cileos"
      But I should not see link "Hinzufügen"

  Scenario: Show all organizations on account page for an owner
    Given I follow "Tepco GmbH" within the navigation
     Then I should be on the page of the account "tepco"
      And I should see the following table of organizations:
       | Name         |
       | Fukushima    |
       | Tschernobyl  |
     When I follow "Fukushima"
     Then I should be on the page of the organization "Fukushima"

  Scenario: Only show organizations on account page where employee is a member
    Given I follow "Cileos UG" within the navigation
     Then I should be on the page of the account "cileos"
      And I should see the following table of organizations:
       | Name                   |
       | Clockwork Programming  |
     When I follow "Clockwork Programming"
     Then I should be on the page of the organization "clockwork programming"
