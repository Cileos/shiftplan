@javascript
Feature: View Teams over weekdays in plan
  In order to drop employees into their teams
  As a planer
  I want a view on my plan with a grid of teams over weekdays

  Background:
    Given today is 2012-12-04
      And the situation of a nuclear reactor

  Scenario: just looking at the view with one scheduled employee
    Given the employee "Homer" was scheduled in the plan as following:
        | week | cwday | quickie                 |
        | 49   | 1     | 9-17 Reaktor putzen     |
        | 49   | 2     | 10-16 Lampen betrachten |
        | 49   | 3     | 11-15 Reaktor putzen    |
        | 49   | 4     | 12-14 Lampen betrachten |
      And I am on the page of the plan
     When I choose "Teams" from the drop down "Mitarbeiter" within the calendar
     Then I should be on the teams in week page of the plan for year: 2012, week: 49
      And I should see the following calendar:
       | Teams             | Mo           | Di            | Mi            | Do            | Fr |
       | Lampen betrachten |              | Homer S 10-16 |               | Homer S 12-14 |    |
       | Reaktor putzen    | Homer S 9-17 |               | Homer S 11-15 |               |    |

  Scenario: create a scheduling by clicking in cell and filling out form in modal
    Given a team exists with name: "Reaktor putzen", organization: the organization
      And I am on the teams in week page of the plan for year: 2012, week: 49
     When I click on cell "Di"/"Reaktor putzen"
      And I fill in the empty "Quickie" with "9-17" and select "Homer S" as "Mitarbeiter"

     Then I should be on the teams in week page of the plan for year: 2012, week: 49
      And I should see the following calendar:
       | Teams          | Mo | Di           | Mi | Do | Fr |
       | Reaktor putzen |    | Homer S 9-17 |    |    |    |

  Scenario: editing a single scheduling by clicking in cell and filling out form in modal
    Given the employee "Homer" was scheduled in the plan as following:
        | week | cwday | quickie                 |
        | 49   | 2     | 9-17 Reaktor putzen     |
      And I am on the teams in week page of the plan for year: 2012, week: 49

     When I click on the scheduling "9-17"
     # TODO should not show team in quickie?
     Then I should be able to change the "Quickie" from "9-17 Reaktor putzen [Rp]" to "1-23" and select "Lenny L" as "Mitarbeiter"
      And I should see the following calendar:
       | Teams          | Mo | Di           | Mi | Do | Fr |
       | Reaktor putzen |    | Lenny L 1-23 |    |    |    |

  @todo
  Scenario: change team? How? clear it by just entering "1-23" as quickie?

  @todo
  Scenario: clicking in row A, but entering Team B in quickie


  Scenario: commenting an existing scheduling
    Given the employee "Homer" was scheduled in the plan as following:
        | week | cwday | quickie                 |
        | 49   | 2     | 9-17 Reaktor putzen     |
      And I am on the teams in week page of the plan for year: 2012, week: 49
     When I follow the comments link within cell "Di"/"Reaktor putzen"
      And I comment "Excellent!"
     Then I should see "1" within the comment link within cell "Di"/"Reaktor putzen"
