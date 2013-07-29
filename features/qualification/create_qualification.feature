Feature: Create Qualifications
  As a planner
  I want to create qualifications
  In order to be able to assign them to employees and to demands of plan templates

  Background:
    Given mr burns, owner of the Springfield Nuclear Power Plant exists
      And I am signed in as the user "mr burns"


  @javascript
  Scenario: Create qualification
    Given I go to the qualifications page for the organization
     Then I should see "Es existieren noch keine Qualifikationen für diese Organisation."

     When I follow "Hinzufügen"
      And I wait for the modal box to appear
      And I fill in "Name" with "Brennstabpolierer"
      And I press "Anlegen"
      And I wait for the modal box to disappear
     Then a qualification should exist with account: the account
      And I should be on the qualifications page for the organization
      And I should see the following table of qualifications:
        | Name              |
        | Brennstabpolierer |
      And I should see notice "Qualifikation erfolgreich angelegt."

  Scenario: List qualifications of own accounts only
    Given an account "cileos" exists
      And a qualification exists with name: "Brennstabexperte", account: the account "cileos"
      And a qualification exists with name: "Brennstabpolierer", account: the account "springfield"

     When I go to the qualifications page for the organization
     Then I should see the following table of qualifications:
        | Name              |
        | Brennstabpolierer |
