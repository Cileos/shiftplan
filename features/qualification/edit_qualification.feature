@javascript
Feature: Edit Qualifications
  As a planner
  I want to edit qualifications
  In order to be able fix typos in the name

  Scenario: Edit qualification
    Given mr burns, owner of the Springfield Nuclear Power Plant exists
      And a qualification exists with name: "Brennstabpolierer", account: the account
      And I am signed in as the user "mr burns"

     When I go to the qualifications page for the organization
     Then I should see the following table of qualifications:
        | Name              |
        | Brennstabpolierer |

     When I follow "Bearbeiten" within the first table row
      And I wait for the modal box to appear
      And I fill in "Name" with "Brennstabexperte"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should be on the qualifications page for the organization
      And I should see the following table of qualifications:
        | Name             |
        | Brennstabexperte |
      And I should see notice "Qualifikation erfolgreich geändert."
