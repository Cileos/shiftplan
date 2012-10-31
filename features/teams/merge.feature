@javascript
Feature: Merge Teams
  In order to remove double teams caused by wrongly typing the name
  As a Planer
  I want to merge 2 teams to one

  Scenario: merge two teams
    Given today is 2012-12-18
    Given the situation of a nuclear reactor
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
     When I check the checkbox within the first table row
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
