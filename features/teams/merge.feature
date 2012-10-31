@javascript
Feature: Merge Teams
  In order to remove double teams caused by wrongly typing the name
  As a Planer
  I want to merge 2 teams to one

  Background:
    Given today is 2012-12-18
      And the situation of a nuclear reactor
      And the employee "Homer" was scheduled in the plan as following:
        | date       | quickie               |
        | 2012-12-21 | 1-2 Reaktor putzen    |
        | 2012-12-22 | 2-3 Reaktor schrubben |
      And the employee "Lenny" was scheduled in the plan as following:
        | date       | quickie               |
        | 2012-12-21 | 2-3 Reaktor schrubben |
        | 2012-12-22 | 3-4 Reaktor putzen    |
      And I am on the page for teams of the organization
      And I should see the following table of teams:
       | Name              | Kürzel |
       | Reaktor putzen    | Rp     |
       | Reaktor schrubben | Rs     |

  Scenario: merge two teams
    Given I check the checkbox within the first table row
      And I check the checkbox within the second table row
      And I press "Zusammenlegen"
      And I wait for the modal box to appear
     When I select "Reaktor schrubben" from "Neuer Teamname"
      And I press "Bestätigen"
      And I wait for the modal box to disappear
     Then I should be on the page for teams of the organization
      And I should see info "Teams erfolgreich zusammengelegt."
      And I should see the following table of teams:
       | Name              | Kürzel |
       | Reaktor schrubben | Rs     |
     When I go to the page of the plan
     Then I should see the following calendar:
        | Mitarbeiter | Fr     | Sa     |
        | Carl C      |        |        |
        | Lenny L     | 2-3 Rs | 3-4 Rs |
        | Homer S     | 1-2 Rs | 2-3 Rs |


  Scenario: merge button should be disabled when visiting the teams page
     Given I press "Zusammenlegen"
     # nothing should happen because the button is disabled, two checkboxes
     # must be checked to merge teams
     Then the modal box should not appear

  Scenario: merge button should be disabled when only one checkbox was clicked so far
    Given I check the checkbox within the first table row
      And I press "Zusammenlegen"
     # nothing should happen because the button is still disabled, two
     # checkboxes must be checked to merge teams
     Then the modal box should not appear

  Scenario: after adding a team the the activated merge button should be disabled again
    # activate merge button by checking two boxes
    Given I check the checkbox within the first table row
      And I check the checkbox within the second table row

     When I follow "Hinzufügen"
      And I wait for the modal box to appear
      And I fill in "Name" with "Müll rausbringen"
      And I press "Anlegen"
      And I wait for the modal box to disappear

     When I press "Zusammenlegen"
     Then the modal box should not appear

  Scenario: after adding a team the on click handlers for the checkboxes should still work
    Given I follow "Hinzufügen"
      And I wait for the modal box to appear
      And I fill in "Name" with "Müll rausbringen"
      And I press "Anlegen"
      And I wait for the modal box to disappear

     When I check the checkbox within the second table row
      And I check the checkbox within the third table row
      And I press "Zusammenlegen"
     Then the modal box should appear

  Scenario: the merge button should be disabled again after a team merge
    Given I check the checkbox within the first table row
      And I check the checkbox within the second table row
      And I press "Zusammenlegen"
      And I wait for the modal box to appear
      And I select "Reaktor schrubben" from "Neuer Teamname"
      And I press "Bestätigen"
      And I wait for the modal box to disappear
      And I should see info "Teams erfolgreich zusammengelegt."

     When I press "Zusammenlegen"
     # nothing should happen because the button is disabled again after
     # two teams have been merged
     Then the modal box should not appear

  Scenario: after merging teams the on click handlers for the checkboxes should still work
    Given a team exists with name: "Müll rausbringen", organization: the organization
      And I am on the page for teams of the organization
      And I should see the following table of teams:
       | Name              | Kürzel |
       | Müll rausbringen  | Mr     |
       | Reaktor putzen    | Rp     |
       | Reaktor schrubben | Rs     |

     When I check the checkbox within the second table row
      And I check the checkbox within the third table row
      And I press "Zusammenlegen"
      And I wait for the modal box to appear
      And I select "Reaktor schrubben" from "Neuer Teamname"
      And I press "Bestätigen"
      And I wait for the modal box to disappear
      And I should see info "Teams erfolgreich zusammengelegt."

     When I check the checkbox within the first table row
      And I check the checkbox within the second table row
      And I press "Zusammenlegen"
     Then the modal box should appear
