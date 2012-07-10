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

  @javascript
  Scenario: create a scheduling by clicking in cell and filling out form in modal
    Given a team exists with name: "Reaktor putzen", organization: the organization
      And I am on the teams in week page of the plan for year: 2012, week: 49
     When I click on cell "Di"/"Reaktor putzen"
      And I wait for the new scheduling form to appear
     Then the "Quickie" field should be empty
     When I fill in "Quickie" with "9-17"
      And I select "Homer S" from "Mitarbeiter"
      And I pause
      And I press "Anlegen"
      And I pause
      And I wait for the new scheduling form to disappear
     Then I should be on the teams in week page of the plan for year: 2012, week: 49
      And I should see the following calendar:
       | Teams          | Mo | Di           | Mi | Do | Fr |
       | Reaktor putzen |    | Homer S 9-17 |    |    |    |


  @todo
  Scenario: clicking in row A, but entering Team B in quickie

