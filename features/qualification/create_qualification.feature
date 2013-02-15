Feature: Create Qualifications
  As a planner
  I want to create qualifications
  In order to be able to assign them to employees and to demands of plan templates

  Background:
    Given the situation of a just registered user


  Scenario: Create qualification
     When I follow "Qualifikationen"
     Then I should be on the qualifications page for the account
      And I should see "Es existieren noch keine Qualifikationen für diese Organisation."

     When I follow "Hinzufügen"
     Then I should be on the new qualification page for the account
     When I fill in "Name" with "Brennstabpolierer"
      And I press "Anlegen"
     Then a qualification should exist with account: the account
      And I should be on the qualifications page for the account
      And I should see the following table of qualifications:
        | Name              |
        | Brennstabpolierer |
      And I should see notice "Qualifikation erfolgreich angelegt."


  Scenario: List qualifications of own accounts only
    Given an account "cileos" exists
      And a qualification exists with name: "Brennstabexperte", account: the account "cileos"
      And a qualification exists with name: "Brennstabpolierer", account: the account "tepco"

     When I go to the qualifications page for the account "tepco"
     Then I should see the following table of qualifications:
        | Name              |
        | Brennstabpolierer |
