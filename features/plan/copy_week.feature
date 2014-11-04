@javascript
Feature: Plan a week

  Background:
    Given today is 2013-02-19
      And the situation of a nuclear reactor


  # TODO do not copy schedulings of deactivated employee
  Scenario: copy from last week
    Given the employee "Homer" was scheduled in the plan as following:
      | year | week | cwday | quickie  |
      | 2012 | 48   | 1     | 5-7      |
      | 2012 | 49   | 2     | 10-10:15 |
      | 2012 | 49   | 3     | 11-12:45 |
      | 2012 | 49   | 4     | 12-13    |
      And I am on the employees in week page of the plan for week: 50, cwyear: 2012
     When I choose "Übernahme aus der letzten Woche" from the drop down "Weitere Aktionen"
      And I wait for the modal box to appear
     Then the "Von" field should contain "2012/49"
      And the "Nach" field should contain "2012/50"
      And I press "Übernehmen"
     Then I should be on the employees in week page of the plan for cwyear: 2012, week: 50
      And I should see "Alle Termine wurden erfolgreich übernommen."
      And I should see a calendar titled "Cleaning the Reactor"
      And I should see "KW 50 / 2012" within active week
      And I should see "10.12." within weeks first date
      And I should see the following partial calendar:
        | Mitarbeiter    | Mo  | Di           | Mi           | Do           | Fr  |
        | Planner Burns  |     |              |              |              |     |
        | Carl C         |     |              |              |              |     |
        | Lenny L        |     |              |              |              |     |
        | Homer S        |     | 10:00-10:15  | 11:00-12:45  | 12:00-13:00  |     |

      When I press "Rückgängig machen"
      Then I should see notice "Die kopierte Woche wurde gelöscht."
      And I should see the following partial calendar:
        | Mitarbeiter    | Mo  | Di           | Mi           | Do           | Fr  |
        | Planner Burns  |     |              |              |              |     |
        | Carl C         |     |              |              |              |     |
        | Lenny L        |     |              |              |              |     |
        | Homer S        |     |              |              |              |     |
      And I should not see "Rückgängig machen"

  Scenario: copy to next week
    Given I am on the employees in week page of the plan for week: 50, cwyear: 2012
     When I choose "Übernahme in die nächste Woche" from the drop down "Weitere Aktionen"
      And I wait for the modal box to appear
     Then the "Von" field should contain "2012/50"
      And the "Nach" field should contain "2012/51"
