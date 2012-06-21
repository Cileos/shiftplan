Feature: View teams over hours of a day in plan
  In order to finely schedule my employees by teams
  As a planer
  I want specify work times by dragging time bars for a single day

  Scenario: just looking at the view with one scheduled employee
    Given today is 2012-12-04
      And the situation of a nuclear reactor
      And the employee "Homer" was scheduled in the plan as following:
        | week | cwday | quickie                      |
        | 49   | 1     | 9-17 Reaktor putzen          |
        | 49   | 1     | 17-20 Lampen betrachten      |
        | 49   | 2     | 11-15 Abklingbecken trocknen |
      And the employee "Lenny" was scheduled in the plan as following:
        | week | cwday | quickie              |
        | 49   | 1     | 12-19 Reaktor putzen |
      And I am on the page of the plan
     When I follow "Tag"
     Then I should see the following time bars:
      """
      "Reaktor putzen"        |9-"Homer S"-17|    
                                 |12-"Lenny L"-19|
      "Lampen betrachten"                    |17-"Homer S"-20|
      """
      But I should not see "Abklingbecken trocknen"
