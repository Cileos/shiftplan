@wip
@javascript
Feature: View teams over hours of a day in plan
  In order to finely schedule my employees by teams
  As a planer
  I want specify work times by dragging time bars for a single day

  Background:
    Given today is Tuesday, the 2012-12-04
      And the situation of a nuclear reactor

  Scenario: just looking at the view with one scheduled employee
    Given the employee "Homer" was scheduled in the plan as following:
        | week | cwday | quickie                      |
        | 49   | 1     | 9-17 Reaktor putzen          |
        | 49   | 1     | 17-20 Lampen betrachten      |
        | 49   | 2     | 11-15 Abklingbecken trocknen |
      And the employee "Lenny" was scheduled in the plan as following:
        | week | cwday | quickie              |
        | 49   | 1     | 12-19 Reaktor putzen |
      And I am on the page of the plan
     When I follow "Tag"
     Then I should be on the teams in day page of the plan for year: 2012, month: 12, day: 03
      And I should see the following time bars:
      """
      "Reaktor putzen"        |9-"Homer S"-17|
                                 |12-"Lenny L"-19|
      "Lampen betrachten"                    |17-"Homer S"-20|
      "Abklingbecken trocknen"
      """

  @todo
  Scenario: looking at schedulings without assigned teams

  Scenario: create a scheduling by clicking in free space and filling out form in modal
    Given a team exists with name: "Reaktor putzen", organization: the organization
      And a team exists with name: "Brennstäbe wechseln", organization: the organization
      And I am on the teams in day page of the plan for year: 2012, month: 12, day: 04
     When I click on the "Reaktor putzen" row
      And I fill in the empty "Quickie" with "9-17" and select "Homer S" as "Mitarbeiter"
     Then I should be on the teams in day page of the plan for year: 2012, month: 12, day: 04
      And I should see the following time bars:
      """
      "Reaktor putzen"        |9-"Homer S"-17|
      "Brennstäbe wechseln"
      """

  Scenario: editing a single scheduling by clicking in cell and filling out form in modal
    Given the employee "Homer" was scheduled in the plan as following:
        | week | cwday | quickie                 |
        | 49   | 2     | 9-17 Reaktor putzen     |
      And I am on the teams in day page of the plan for year: 2012, month: 12, day: 04

     When I click on the scheduling "9-17"
     # TODO should not show team in quickie?
     Then I should be able to change the "Quickie" from "9-17 Reaktor putzen [Rp]" to "1-23" and select "Lenny L" as "Mitarbeiter"
      And I should see the following time bars:
      """
      "Reaktor putzen"        |1-"Lenny L"-23|
      """

  Scenario: moving a scheduling to another (pre-existing) team by editing the quickie it in the modal form
    Given the employee "Homer" was scheduled in the plan as following:
        | week | cwday | quickie                      |
        | 49   | 2     | 9-17 Reaktor putzen          |
      And a team exists with name: "Brennstäbe wechseln", organization: the organization
      And I am on the teams in day page of the plan for year: 2012, month: 12, day: 04
     When I click on the scheduling "9-17"
      And I schedule "10-18 Brennstäbe wechseln" and select "Homer S" as "Mitarbeiter"
     Then I should see the following time bars:
      """
      "Reaktor putzen"
      "Brennstäbe wechseln"  |10-"Homer S"-18|
      """

  @todo
  Scenario: moving a scheduling to a new team by editing the quickie it in the modal form, creating a new row in the table

  Scenario: commenting an existing scheduling
    Given the employee "Homer" was scheduled in the plan as following:
        | week | cwday | quickie                 |
        | 49   | 2     | 9-17 Reaktor putzen     |
      And I am on the teams in day page of the plan for year: 2012, month: 12, day: 04
     When I follow "Kommentare" within the calendar
      And I comment "Excellent!"
     Then I should see "1" within the comment link within the calendar
