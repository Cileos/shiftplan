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
      And I follow "Teams"
      And I should see the following table of teams:
       | Name              | Kürzel |
       | Reaktor putzen    | Rp     |
       | Reaktor schrubben | Rs     |
     When I follow "Reaktor putzen"
      And I follow "Zusammenlegen"
      And I select "Reaktor schrubben" from "anderes Team"
      And I press "Zusammenlegen"
     Then I should see info "Teams erfolgreich zusammengeführt."
      And I should see the following table of teams:
       | Name           | Kürzel |
       | Reaktor putzen | Rp     |
      But I should not see "Reaktor schrubben"
     When I go to the page of the plan
     Then I should see the following calendar:
        | Mitarbeiter | Freitag | Samstag |
        | Carl C      |         |         |
        | Lenny L     | 2-3 Rp  | 3-4 Rp  |
        | Homer S     | 1-2 Rp  | 2-3 Rp  |
