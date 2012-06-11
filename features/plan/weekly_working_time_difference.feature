Feature: Weekly working time difference
  As the planner
  I want to see the difference between the waz and the sum of hours of the employees

  Background:
    Given today is 2012-12-18
    And the situation of a nuclear reactor

  Scenario: Employee without weekly working time
    Given the employee "Lenny" was scheduled in the plan as following:
      | date       | quickie             |
      | 2012-12-17 | 8-16 Reaktor putzen |
    When I go to the page of the plan "clean reactor"
    Then the employee "Lenny L" should have a grey hours/waz value of "8"

  Scenario: Underscheduled employee
    Given the employee "Homer" was scheduled in the plan as following:
      | date       | quickie             |
      | 2012-12-17 | 8-16 Reaktor putzen |
    When I go to the page of the plan "clean reactor"
    Then the employee "Homer S" should have a yellow hours/waz value of "8 / 40"

  Scenario: Exactly scheduled employee
    Given the employee "Homer" was scheduled in the plan as following:
      | date       | quickie             |
      | 2012-12-17 | 8-16 Reaktor putzen |
      | 2012-12-18 | 8-16 Reaktor putzen |
      | 2012-12-19 | 8-16 Reaktor putzen |
      | 2012-12-20 | 8-16 Reaktor putzen |
      | 2012-12-21 | 8-16 Reaktor putzen |
    When I go to the page of the plan "clean reactor"
    Then the employee "Homer S" should have a green hours/waz value of "40 / 40"

  Scenario: Overscheduled employee
    Given the employee "Homer" was scheduled in the plan as following:
      | date       | quickie              |
      | 2012-12-17 | 8-16 Reaktor putzen  |
      | 2012-12-18 | 8-16 Reaktor putzen  |
      | 2012-12-19 | 8-16 Reaktor putzen  |
      | 2012-12-20 | 8-16 Reaktor putzen  |
      | 2012-12-21 | 8-16 Reaktor putzen  |
      | 2012-12-21 | 17-18 Reaktor putzen |
    When I go to the page of the plan "clean reactor"
    Then the employee "Homer S" should have a red hours/waz value of "41 / 40"
