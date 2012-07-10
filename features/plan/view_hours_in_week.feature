@javascript
Feature: View hours over weekdays in plan
  In order to drag & drop schedulings with precision of an hour
  As a planer
  I want a view on my plan similar to google calendar's start view

  Background:
    Given today is 2012-12-04
      And the situation of a nuclear reactor

  Scenario: just looking at the view with one scheduled employee
    Given the employee "Homer" was scheduled in the plan as following:
        | week | cwday | quickie             |
        | 49   | 1     | 9-17                |
        | 49   | 2     | 10-16               |
        | 49   | 3     | 11-15               |
        | 49   | 4     | 12-14 fest Schlafen |
      And I am on the page of the plan
     When I choose "Stunden" from the drop down "Mitarbeiter" within the calendar
     Then I should be on the hours in week page of the plan for year: 2012, week: 49
     Then I should see the following calendar:
       | Mo           | Di            | Mi            | Do               | Fr |
       | Homer S 9-17 | Homer S 10-16 | Homer S 11-15 | Homer S 12-14 fS |    |

  Scenario: creating a new scheduling by clicking in the day column and filling out the modal form
    Given I am on the hours in week page of the plan for year: 2012, week: 49
     When I click on the "Di" column
      And I wait for the new scheduling form to appear
     Then the selected "Wochentag" should be "Dienstag"
      And the "Quickie" field should be empty
     When I fill in "Quickie" with "9-17 Reaktor putzen"
      And I select "Lenny L" from "Mitarbeiter"
      And I press "Anlegen"
      And I wait for the new scheduling form to disappear
     Then I should see the following calendar:
       | Mo | Di              | Mi | Do | Fr |
       |    | Lenny L 9-17 Rp |    |    |    |

