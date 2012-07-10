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
      And I wait for the new scheduling form to appear
     Then the "Quickie" field should be empty
     When I fill in "Quickie" with "9-17"
      And I select "Homer S" from "Mitarbeiter"
      And I press "Anlegen"
      And I wait for the new scheduling form to disappear
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
      And I wait for the modal box to appear
     Then the "Quickie" field should contain "9-17" within the modal box

     # invalid Quickie produces error
     When I fill in "Quickie" with "1-" within the modal box
      And I press "Speichern"
     Then I should see "Quickie ist nicht gültig" within errors within the modal box

     When I fill in "Quickie" with "1-23" within the modal box
      And I select "Lenny L" from "Mitarbeiter"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
       | Teams          | Mo | Di           | Mi | Do | Fr |
       | Reaktor putzen |    | Lenny L 1-23 |    |    |    |

  @todo
  Scenario: change team?

  @todo
  Scenario: clicking in row A, but entering Team B in quickie


  Scenario: commenting an existing scheduling
    Given the employee "Homer" was scheduled in the plan as following:
        | week | cwday | quickie                 |
        | 49   | 2     | 9-17 Reaktor putzen     |
      And I am on the teams in week page of the plan for year: 2012, week: 49
     When I follow "Kommentare" within cell "Di"/"Reaktor putzen"
      And I wait for the modal box to appear
      And I fill in "Kommentar" with "Excellent!"
      And I press "Kommentieren"
      And I wait for the spinner to disappear
     Then the "Kommentar" field should be empty
      And I should see "Sie haben am 04.12.2012 um 00:00 Uhr geschrieben:" within comments within the modal box
      And I should see "Excellent!" within comments within the modal box
     When I close the modal box
     Then I should see "1" within the comment link within cell "Di"/"Reaktor putzen"
