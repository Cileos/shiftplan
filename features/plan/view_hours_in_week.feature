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
     Then I should be on the hours in week page of the plan for cwyear: 2012, week: 49
     Then I should see the following calendar:
       | Mo                   | Di                   | Mi                   | Do                      | Fr  |
       | Homer S 09:00-17:00  | Homer S 10:00-16:00  | Homer S 11:00-15:00  | Homer S 12:00-14:00 fS  |     |

  Scenario: creating a new scheduling by clicking in the day column and filling out the modal form
    Given I am on the hours in week page of the plan for cwyear: 2012, week: 49
     When I click on the "Di" column
      And I wait for the new scheduling form to appear
     Then the selected "Wochentag" should be "Dienstag"
      And the "Quickie" field should be empty
     When I fill in "Quickie" with "9-17 Reaktor putzen"
      And I select "Lenny L" from "Mitarbeiter"
      And I press "Anlegen"
      And I wait for the new scheduling form to disappear
     Then I should see the following calendar:
       | Mo  | Di                      | Mi  | Do  | Fr  |
       |     | Lenny L 09:00-17:00 Rp  |     |     |     |

  Scenario: editing a single scheduling by clicking on bar in column and filling out form in modal
    Given the employee "Homer" was scheduled in the plan as following:
        | week | cwday | quickie                 |
        | 49   | 2     | 9-17 Reaktor putzen     |
      And I am on the hours in week page of the plan for cwyear: 2012, week: 49

     When I click on the scheduling "09:00-17:00"
     Then I should be able to change the "Quickie" from "9-17 Reaktor putzen [Rp]" to "1-23" and select "Lenny L" as "Mitarbeiter"
      And I should see the following calendar:
       | Mo  | Di                      | Mi  | Do  | Fr  |
       |     | Lenny L 01:00-23:00 Rp  |     |     |     |

  Scenario: commenting an existing scheduling by clicking on bar in column and filling out form in modal
    Given the employee "Homer" was scheduled in the plan as following:
        | week | cwday | quickie            |
        | 49   | 2     | 1-8 Reaktor putzen |
      And I am on the hours in week page of the plan for cwyear: 2012, week: 49
     When I follow the no-comments link within the calendar
      And I comment "Excellently short!"
     Then I should see "1" within the comment link within the calendar
