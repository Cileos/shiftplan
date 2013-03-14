Feature: Edit Qualifications
  As a planner
  I want to edit qualifications
  In order to be able fix typos in the name

  Scenario: Edit qualification
    Given the situation of a just registered user
      And a qualification exists with name: "Brennstabpolierer", account: the account

     When I follow "Qualifikationen"
     Then I should be on the qualifications page for the organization
      And I should see the following table of qualifications:
        | Name              |
        | Brennstabpolierer |

     When I follow "Bearbeiten" within the first table row
      And I fill in "Name" with "Brennstabexperte"
      And I press "Speichern"
     Then I should be on the qualifications page for the organization
      And I should see the following table of qualifications:
        | Name             |
        | Brennstabexperte |
      And I should see notice "Qualifikation erfolgreich geändert."
