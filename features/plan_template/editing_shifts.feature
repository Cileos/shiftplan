@wip
@minutes
@javascript
Feature: Editing shifts of plan templates
  As a planner
  I want to edit the shifts of my plan templates
  In order to be able to change the demands which exist for a typical work week in my organization

  Background:
    Given the situation of a just registered user
      And the situation of a plan template organization

  Scenario: Editing shifts of a plan template
    Given I click on the shift "04:00-12:00"
      And I wait for the modal box to appear
      And I select "13" from "Endstunde"
      And I select "Brennstabkessel" from "Team"
      And I select "Mittwoch" from "Tag"
      And I fill in the 1st "Anzahl" with "1"
      And I fill in the 2nd "Anzahl" with "3"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
        | Teams                  | Mo  | Di  | Mi                                                      | Do  | Fr  | Sa  | So  |
        | Brennstabkessel(B)     |     |     | 04:00-13:00 3 x Brennstabexperte 1 x Brennstabpolierer  |     |     |     |     |
        | Druckwasserreaktor(D)  |     |     |                                                         |     |     |     |     |
