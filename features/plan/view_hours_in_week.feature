@javascript
Feature: View hours over weekdays in plan
  In order to drag & drop schedulings with precision of an hour
  As a planer
  I want a view on my plan similar to google calendar's start view

  Scenario: just looking at the view with one scheduled employee
    Given today is 2012-12-04
      And the situation of a nuclear reactor
      And the employee "Homer" was scheduled in the plan as following:
        | week | cwday | quickie |
        | 49   | 1     | 9-17    |
        | 49   | 2     | 10-16   |
        | 49   | 3     | 11-15   |
        | 49   | 4     | 12-14   |
      And I am on the page of the plan
     When I choose "Stunden" from the drop down "Mitarbeiter" within the calendar
     Then I should see the following calendar with hours in week:
       | Mo           | Di            | Mi            | Do            | Fr |
       | 9-17 Homer S | 10-16 Homer S | 11-15 Homer S | 12-14 Homer S |    |

