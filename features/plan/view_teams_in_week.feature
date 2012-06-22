Feature: View Teams over weekdays in plan
  In order to drop employees into their teams
  As a planer
  I want a view on my plan with a grid of teams over weekdays

  Scenario: just looking at the view with one scheduled employee
    Given today is 2012-12-04
      And the situation of a nuclear reactor
      And the employee "Homer" was scheduled in the plan as following:
        | week | cwday | quickie                 |
        | 49   | 1     | 9-17 Reaktor putzen     |
        | 49   | 2     | 10-16 Lampen betrachten |
        | 49   | 3     | 11-15 Reaktor putzen    |
        | 49   | 4     | 12-14 Lampen betrachten |
      And I am on the page of the plan
     When I choose "Teams" from the drop down "Mitarbeiter" within the calendar
     Then I should see the following calendar:
       | Teams             | Mo           | Di            | Mi            | Do            | Fr |
       | Lampen betrachten |              | Homer S 10-16 |               | Homer S 12-14 |    |
       | Reaktor putzen    | Homer S 9-17 |               | Homer S 11-15 |               |    |

