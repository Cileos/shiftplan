@javascript
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
      And I am on the accounts page

  Scenario: Create another organization
     # user is owner of account "tepco" so he can create new organizations
     When I follow "Organisation hinzufügen" for the account "tepco"
      And I wait for the modal box to appear
      And I fill in "Name" with "Nuclear Cleanup Inc."
      And I press "Anlegen"
      And I wait for the modal box to disappear
     Then I should see notice "Organisation 'Nuclear Cleanup Inc.' angelegt."
      And I should be on the accounts page
      And I should see the following table for the account "cileos":
       | Cileos UG             |
       | Clockwork Programming |
      And I should see the following table for the account "tepco":
       | Tepco GmbH            |
       | Fukushima             |
       | Nuclear Cleanup Inc.  |
       | Tschernobyl           |
     Then I should see link "Organisation hinzufügen" within the table for the account "tepco"
     # can not create organizations in other accounts as non-owner
      But I should not see link "Organisation hinzufügen" within the table for the account "cileos"

  Scenario: Edit organization
     When I follow "Bearbeiten" within the first table row within the table for the account "tepco"
      And I wait for the modal box to appear
      And I fill in "Name" with "Fukushima Reaktor 1"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should be on the accounts page
      And I should see the following table for the account "tepco":
        | Tepco GmbH          |
        | Fukushima Reaktor 1 |
        | Tschernobyl         |
