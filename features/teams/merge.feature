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
      And a team exists with name: "Überwachen", organization: the organization
      And I am on the page for teams of the organization
      And I should see the following table of teams:
       | Name              | Kürzel |
       | Reaktor putzen    | Rp     |
       | Reaktor schrubben | Rs     |
       | Überwachen        | Ü      |

  Scenario: merge two teams
    Given the merge button should be disabled

     When I check the checkbox within the first table row
     Then the merge button should be disabled

     When I check the checkbox within the second table row
     Then the merge button should not be disabled

     When I press "Zusammenlegen"
      And I wait for the modal box to appear
      And I select "Reaktor schrubben" from "Neuer Teamname"
      And I press "Bestätigen"
      And I wait for the modal box to disappear
     Then I should be on the page for teams of the organization
      And I should see notice "Teams erfolgreich zusammengelegt."
      And the merge button should be disabled
      And I should see the following table of teams:
       | Name              | Kürzel |
       | Reaktor schrubben | Rs     |
       | Überwachen        | Ü      |

     #  the on click handlers for the checkboxes should still work
     When I check the checkbox within the first table row
      And I check the checkbox within the second table row
     Then the merge button should not be disabled

     # Schedulings were re-assigned
     When I go to the page of the plan
     Then I should see the following partial calendar:
        | Mitarbeiter  | Fr              | Sa              |
        | Carl C       |                 |                 |
        | Lenny L      | 02:00-03:00 Rs  | 03:00-04:00 Rs  |
        | Homer S      | 01:00-02:00 Rs  | 02:00-03:00 Rs  |
      And I should see "Reaktor schrubben" within the legend
      But I should not see "Reaktor putzen" within the legend


  Scenario: Adding a team does not disturb the merge interface
    # activate merge button by checking two boxes
     When I check the checkbox within the first table row
      And I check the checkbox within the second table row
     Then the merge button should not be disabled

     When I follow "Hinzufügen"
      And I wait for the modal box to appear
      And I fill in "Name" with "Müll rausbringen"
      And I press "Anlegen"
      And I wait for the modal box to disappear

     Then the merge button should be disabled

     #  the on click handlers for the checkboxes should still work
     When I check the checkbox within the second table row
      And I check the checkbox within the third table row
     Then the merge button should not be disabled

     When I press "Zusammenlegen"
     Then the modal box should appear
