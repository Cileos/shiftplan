@javascript
Feature: Editing shifts of plan templates
  As a planner
  I want to edit the shifts of my plan templates
  In order to be able to change the demands which exist for a typical work week in my organization

  Scenario: Editing shifts of a plan template
    Given mr burns, owner of the Springfield Nuclear Power Plant exists
      And the situation of a plan template organization

     When I am signed in as the user "mr burns"
      And I go to the teams in week page for the plan template
      And I click on the shift "04:00-12:00"
      And I wait for the modal box to appear
      And I fill in "Endzeit" with "13"
      And I select "Brennstabkessel" from the "Team" single-select box
      And I select "Mittwoch" from "Tag"
      And I fill in the 1st "Anzahl" with "1"
      And I fill in the 2nd "Anzahl" with "3"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
        | Teams                  | Mo  | Di  | Mi                                                      | Do  | Fr  | Sa  | So  |
        | Brennstabkessel(B)     |     |     | 04:00-13:00 3 x Brennstabexperte 1 x Brennstabpolierer  |     |     |     |     |
        | Druckwasserreaktor(D)  |     |     |                                                         |     |     |     |     |
