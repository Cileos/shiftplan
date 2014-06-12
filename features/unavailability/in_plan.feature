Feature: Unavailabilities in plan
  In order to avoid trial and error to find a working employee
  As a planner
  I want to see the unavailabilities of my employees in the the plan

  Background:
    Given today is 2012-12-18
      And the situation of a nuclear reactor

  Scenario: sick day is seen in advance
    Given an unavailability exists with reason: "illness", employee: the employee "Homer", starts_at: "2012-12-19 6:00", ends_at: "2012-12-19 18:00"
     When I go to the page of the plan "clean reactor"
     Then I should see the following partial calendar:
        | Mitarbeiter   | Mo | Di | Mi                    | Do | Fr | Sa | So |
        | Planner Burns |    |    |                       |    |    |    |    |
        | Carl C        |    |    |                       |    |    |    |    |
        | Lenny L       |    |    |                       |    |    |    |    |
        | Homer S       |    |    | 06:00-18:00 Krankheit |    |    |    |    |

