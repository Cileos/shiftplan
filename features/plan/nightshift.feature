Feature: Nightshift
  In order to let my employees work over night
  As a planner
  I want to schedule a shift that begins today and ends tomorrow

  @javascript
  Scenario: create and edit a nightshift
    Given the situation of a nuclear reactor
     When I schedule "Homer S" on "Do" for "19-00:30"
     Then I should see the following partial calendar:
        | Mitarbeiter   | Mo | Di | Mi | Do          | Fr          | Sa | So |
        | Planner Burns |    |    |    |             |             |    |    |
        | Carl C        |    |    |    |             |             |    |    |
        | Lenny L       |    |    |    |             |             |    |    |
        | Homer S       |    |    |    | 19:00-00:30 | 19:00-00:30 |    |    |
      And the employee "Homer S" should have a yellow hours/waz value of "5½ / 40"

     When I click on the early scheduling "19:00-00:30"
     And I reschedule "20-5:00" and select "Lenny L" as "Mitarbeiter" in the single-select box
     Then I should see the following partial calendar:
        | Mitarbeiter   | Mo | Di | Mi | Do          | Fr          | Sa | So |
        | Planner Burns |    |    |    |             |             |    |    |
        | Carl C        |    |    |    |             |             |    |    |
        | Lenny L       |    |    |    | 20:00-05:00 | 20:00-05:00 |    |    |
        | Homer S       |    |    |    |             |             |    |    |
      And the employee "Homer S" should have a yellow hours/waz value of "0 / 40"
      And the employee "Lenny L" should have a grey hours/waz value of "9"

     When I click on the late scheduling "20:00-05:00"
      And I wait for the modal box to appear
      And I choose "Mi"
      And I press "Speichern"
      And I wait for the modal box to disappear

     Then I should see the following partial calendar:
        | Mitarbeiter   | Mo | Di | Mi          | Do          | Fr | Sa | So |
        | Planner Burns |    |    |             |             |    |    |    |
        | Carl C        |    |    |             |             |    |    |    |
        | Lenny L       |    |    | 20:00-05:00 | 20:00-05:00 |    |    |    |
        | Homer S       |    |    |             |             |    |    |    |
      And the employee "Lenny L" should have a grey hours/waz value of "9"

     # the half from "previous" day should always come first
     When I schedule "Lenny L" on "Do" for "19-4"
      And I schedule "Lenny L" on "Fr" for "18-3"
     Then I should see the following partial calendar:
        | Mitarbeiter   | Di | Mi          | Do                      | Fr                      | Sa          | So |
        | Lenny L       |    | 20:00-05:00 | 20:00-05:00 19:00-04:00 | 19:00-04:00 18:00-03:00 | 18:00-03:00 |    |
