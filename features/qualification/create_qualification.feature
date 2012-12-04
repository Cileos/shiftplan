Feature: Create Qualifications
  As a planner
  I want to create qualifications
  In order to be able to assign them to employees and to demands of plan templates


  Scenario: Create qualification
    Given the situation of a just registered user
     When I follow "Qualifikationen"
     Then I should be on the qualifications page for the organization
      And I should see "Es existieren noch keine Qualifikationen für diese Organisation."

     When I follow "Hinzufügen"
     Then I should be on the new qualification page for the organization
     When I fill in "Name" with "Brennstabpolierer"
      And I press "Anlegen"
     Then I should be on the qualifications page for the organization
      And I should see the following table of qualifications:
        | Name              |
        | Brennstabpolierer |
      And I should see notice "Qualifikation erfolgreich angelegt."
