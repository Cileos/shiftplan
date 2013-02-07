@javascript
Feature: create a scheduling
  In order for my employees not to miss any of their shifts
  As a planner
  I want to create a scheduling for my employees

  Background:
    Given today is 2012-12-18
      And the situation of a nuclear reactor

  Scenario: Creating and editing an overnight scheduling by clicking on the first day
    Given a team exists with name: "Putzkolonne", organization: the organization
      And I inject style "position:relative" into "header"
     When I follow "Neue Terminierung"
      And I select "Homer S" from "Mitarbeiter"
      And I select "Mittwoch" from "Wochentag"
      And I fill in "Quickie" with "22-6"
      And I press "Anlegen"
     Then I should see the following calendar:
        | Mitarbeiter  | Mo  | Di  | Mi           | Do           | Fr  | Sa  | So  |
        | Carl C       |     |     |              |              |     |     |     |
        | Lenny L      |     |     |              |              |     |     |     |
        | Homer S      |     |     | 22:00-23:59  | 00:00-06:00  |     |     |     |
     And the employee "Homer S" should have a yellow hours/waz value of "8 / 40"
     # edit
     When I click on the scheduling "22:00-23:59"
      And I wait for the modal box to appear
     Then the selected "Startstunde" should be "22"
      And the selected "Endstunde" should be "6"
      And I select "Donnerstag" from "Wochentag"
      And I select "21" from "Startstunde"
      And I select "5" from "Endstunde"
      And I select "Lenny L" from "Mitarbeiter"
      And I select "Putzkolonne" from "Team"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
        | Mitarbeiter  | Do             | Fr             |
        | Carl C       |                |                |
        | Lenny L      | 21:00-23:59 P  | 00:00-05:00 P  |
        | Homer S      |                |                |
      And the employee "Lenny L" should have a grey hours/waz value of "8"
      And the employee "Homer S" should have a yellow hours/waz value of "0 / 40"

  Scenario: Editing an overnight scheduling by clicking on the second day
    Given a team exists with name: "Putzkolonne", organization: the organization
      And the employee "Homer" was scheduled in the plan as following:
        | date       | quickie |
        | 2012-12-19 | 22-6    |
      And I am on the page for the plan
     Then I should see the following calendar:
        | Mitarbeiter  | Mo  | Di  | Mi           | Do           | Fr  | Sa  | So  |
        | Carl C       |     |     |              |              |     |     |     |
        | Lenny L      |     |     |              |              |     |     |     |
        | Homer S      |     |     | 22:00-23:59  | 00:00-06:00  |     |     |     |
      When I click on the scheduling "00:00-06:00"
      And I wait for the modal box to appear
     Then the selected "Startstunde" should be "22"
      And the selected "Endstunde" should be "6"
      And I select "Donnerstag" from "Wochentag"
      And I select "21" from "Startstunde"
      And I select "5" from "Endstunde"
      And I select "Lenny L" from "Mitarbeiter"
      And I select "Putzkolonne" from "Team"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
        | Mitarbeiter  | Do             | Fr             |
        | Carl C       |                |                |
        | Lenny L      | 21:00-23:59 P  | 00:00-05:00 P  |
        | Homer S      |                |                |
