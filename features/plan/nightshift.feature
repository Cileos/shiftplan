Feature: Nightshift
  In order to let my employees work over night
  As a planner
  I want to schedule a shift that begins today and ends tomorrow

  @javascript
  Scenario: entering time span for the nightshift
    Given the situation of a nuclear reactor
     When I schedule "Homer S" on "Do" for "19-6 Daumen drehen"
     Then I should see the following calendar:
        | Mitarbeiter   | Mo | Di | Mi | Do       | Fr     | Sa | So |
        | Planner Burns |    |    |    |          |        |    |    |
        | Carl C        |    |    |    |          |        |    |    |
        | Lenny L       |    |    |    |          |        |    |    |
        | Homer S       |    |    |    | 19-24 Dd | 0-6 Dd |    |    |
