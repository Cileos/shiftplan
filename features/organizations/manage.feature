@javascript
Feature: create organizations
  As an owner of an account with too much chaos
  In order to optimize my plans
  I want to create another organization belonging to the same account

  Background:
    Given mr burns, owner of the Springfield Nuclear Power Plant exists
     When I am signed in as the user "mr burns"
      And a account "cileos" exists with name: "Cileos UG"
      And an organization "cooling towers" exists with name: "Cooling Towers", account: the account "springfield"
      And an organization "clockwork programming" exists with name: "Clockwork Programming", account: the account "cileos"
      And an organization "clockwork marketing" exists with name: "Clockwork Marketing", account: the account "cileos"
      And an employee "charles m. burns" exists with first_name: "Charles M.", last_name: "Burns", account: the account "cileos", user: the user
      And a membership exists with organization: the organization "clockwork programming", employee: the employee "charles m. burns"
      And I am on the accounts page

  Scenario: Create another organization
     # user is owner of account "springfield" so he can create new organizations
     When I follow "Organisation hinzufügen" for the account "springfield"
      And I wait for the modal box to appear
      And I fill in "Name" with "Nuclear Cleanup Inc."
      And I press "Anlegen"
      And I wait for the modal box to disappear
     Then I should see notice "Organisation 'Nuclear Cleanup Inc.' angelegt."
      And I should be on the accounts page
      And I should see the following table for the account "cileos":
       | Cileos UG             |
       | Clockwork Programming |
      And I should see the following table for the account "springfield":
       | Springfield Nuclear Power Plant  |
       | Cooling Towers                   |
       | Nuclear Cleanup Inc.             |
       | Sector 7-G                       |
     Then I should see link "Organisation hinzufügen" within the table for the account "springfield"
     # can not create organizations in other accounts as non-owner
      But I should not see link "Organisation hinzufügen" within the table for the account "cileos"

  Scenario: Edit organization
     When I follow "Bearbeiten" within the first table row within the table for the account "springfield"
      And I wait for the modal box to appear
      And I fill in "Name" with "Cooling Supertowers"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should be on the accounts page
      And I should see the following table for the account "springfield":
        | Springfield Nuclear Power Plant  |
        | Cooling Supertowers  |
        | Sector 7-G           |
