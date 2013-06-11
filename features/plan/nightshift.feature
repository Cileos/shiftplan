Feature: Nightshift
  In order to let my employees work over night
  As a planner
  I want to schedule a shift that begins today and ends tomorrow

  @javascript
  Scenario: create and edit a nightshift
    Given the situation of a nuclear reactor
     When I schedule "Homer S" on "Do" for "19-6 Daumen drehen"
     Then I should see the following partial calendar:
        | Mitarbeiter  | Mo  | Di  | Mi  | Do              | Fr              | Sa  | So  |
        | Carl C       |     |     |     |                 |                 |     |     |
        | Lenny L      |     |     |     |                 |                 |     |     |
        | Homer S      |     |     |     | 19:00-06:00 Dd  | 19:00-06:00 Dd  |     |     |
      And the employee "Homer S" should have a yellow hours/waz value of "11 / 40"

     When I click on the early scheduling "19:00-06:00"
      And I change the "Quickie" from "19-6 Daumen drehen [Dd]" to "20-5 Kresse halten" and select "Lenny L" as "Mitarbeiter"
     Then I should see the following partial calendar:
        | Mitarbeiter  | Mo  | Di  | Mi  | Do              | Fr              | Sa  | So  |
        | Carl C       |     |     |     |                 |                 |     |     |
        | Lenny L      |     |     |     | 20:00-05:00 Kh  | 20:00-05:00 Kh  |     |     |
        | Homer S      |     |     |     |                 |                 |     |     |
      And the employee "Homer S" should have a yellow hours/waz value of "0 / 40"
      And the employee "Lenny L" should have a grey hours/waz value of "9"

     When I click on the late scheduling "20:00-05:00"
      And I wait for the modal box to appear
      And I choose "Mi"
      And I press "Speichern"
      And I wait for the modal box to disappear

     Then I should see the following partial calendar:
        | Mitarbeiter | Mo | Di | Mi             | Do             | Fr | Sa | So |
        | Carl C      |    |    |                |                |    |    |    |
        | Lenny L     |    |    | 20:00-05:00 Kh | 20:00-05:00 Kh |    |    |    |
        | Homer S     |    |    |                |                |    |    |    |
      And the employee "Lenny L" should have a grey hours/waz value of "9"
