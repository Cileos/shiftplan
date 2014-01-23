@javascript
Feature: View Teams over weekdays in plan
  In order to drop employees into their teams
  As a planer
  I want a view on my plan with a grid of teams over weekdays

  Background:
    Given the situation of a nuclear reactor

  Scenario: just looking at the view with one scheduled employee
    Given the employee "Homer" was scheduled in the plan as following:
        | year | week | cwday | quickie                 |
        | 2012 | 49   | 1     | 9-17 Reaktor putzen     |
        | 2012 | 49   | 2     | 10-16 Lampen betrachten |
        | 2012 | 49   | 3     | 11-15 Reaktor putzen    |
        | 2012 | 49   | 4     | 12-14 Lampen betrachten |
      And I am on the teams in week page of the plan for cwyear: 2012, week: 49
     When I choose "Teams" from the drop down "Mitarbeiter" within the calendar
     Then I should be on the teams in week page of the plan for cwyear: 2012, week: 49
      And I should see the following partial calendar:
       | Teams                   | Mo                   | Di                   | Mi                   | Do                   | Fr  |
       | Lampen betrachten (Lb)  |                      | Homer S 10:00-16:00  |                      | Homer S 12:00-14:00  |     |
       | Reaktor putzen (Rp)     | Homer S 09:00-17:00  |                      | Homer S 11:00-15:00  |                      |     |

  Scenario: create a scheduling by clicking in cell and filling out form in modal
    Given a team exists with name: "Reaktor putzen", organization: the organization
      And I am on the teams in week page of the plan for cwyear: 2012, week: 49
     When I click on cell "Di"/"Reaktor putzen (Rp)"
      And I schedule "9-17"
      And I select "Homer S" from the "Mitarbeiter" single-select box
      And I press "Anlegen"
      And I wait for the modal box to disappear

     Then I should be on the teams in week page of the plan for cwyear: 2012, week: 49
      And I should see the following partial calendar:
       | Teams                | Mo  | Di                   | Mi  | Do  | Fr  |
       | Reaktor putzen (Rp)  |     | Homer S 09:00-17:00  |     |     |     |

  Scenario: editing a single scheduling by clicking in cell and filling out form in modal
    Given the employee "Homer" was scheduled in the plan as following:
        | year | week | cwday | quickie             |
        | 2012 | 49   | 2     | 9-17 Reaktor putzen |
      And I am on the teams in week page of the plan for cwyear: 2012, week: 49

     When I click on the scheduling "09:00-17:00"
     # TODO should not show team in quickie?
     Then I reschedule "1-23" and select "Lenny L" as "Mitarbeiter" in the single-select box
      And I should see the following partial calendar:
       | Teams                | Mo  | Di                   | Mi  | Do  | Fr  |
       | Reaktor putzen (Rp)  |     | Lenny L 01:00-23:00  |     |     |     |

  @todo
  Scenario: change team? How? clear it by just entering "1-23" as quickie?

  @todo
  Scenario: clicking in row A, but entering Team B in quickie


  Scenario: commenting an existing scheduling
    Given the employee "Homer" was scheduled in the plan as following:
        | year | week | cwday | quickie             |
        | 2012 | 49   | 2     | 9-17 Reaktor putzen |
      And I am on the teams in week page of the plan for cwyear: 2012, week: 49
     When I follow the no-comments link within cell "Di"/"Reaktor putzen (Rp)"
      And I comment "Excellent!"
     Then I should see "1" within the comment link within cell "Di"/"Reaktor putzen (Rp)"
