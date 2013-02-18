@javascript
Feature: Deleting shifts of plan templates
  As a planner
  I want to delete shifts from my plan templates
  In order to be able to change the demands which exist for a typical work week in my organization

  Background:
    Given the situation of a just registered user
      And the situation of a plan template organization

  Scenario: Deleting shifts of a plan template
    Given I click on the shift "04:00-12:00"
      And I wait for the modal box to appear
      And I follow "Löschen" within ".actions"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
        | Teams                  | Mo  | Di  | Mi  | Do  | Fr  | Sa  | So  |
        | Brennstabkessel(B)     |     |     |     |     |     |     |     |
        | Druckwasserreaktor(D)  |     |     |     |     |     |     |     |
