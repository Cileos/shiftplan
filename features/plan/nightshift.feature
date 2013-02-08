Feature: Nightshift
  In order to let my employees work over night
  As a planner
  I want to schedule a shift that begins today and ends tomorrow

  @javascript
  Scenario: entering time span for the nightshift
    Given the situation of a nuclear reactor
     When I schedule "Homer S" on "Do" for "19-6 Daumen drehen"
     Then I should see the following calendar:
        | Mitarbeiter  | Mo  | Di  | Mi  | Do              | Fr              | Sa  | So  |
        | Carl C       |     |     |     |                 |                 |     |     |
        | Lenny L      |     |     |     |                 |                 |     |     |
        | Homer S      |     |     |     | 19:00-23:59 Dd  | 00:00-06:00 Dd  |     |     |

     When I click on scheduling "00:00-06:00"
      And I change the "Quickie" from "19-6 Daumen drehen [Dd]" to "20-5 Kresse halten" and select "Lenny L" as "Mitarbeiter"
     Then I should see the following calendar:
        | Mitarbeiter  | Mo  | Di  | Mi  | Do              | Fr              | Sa  | So  |
        | Carl C       |     |     |     |                 |                 |     |     |
        | Lenny L      |     |     |     | 20:00-23:59 Kh  | 00:00-05:00 Kh  |     |     |
        | Homer S      |     |     |     |                 |                 |     |     |
