@javascript
Feature: Comment on Schedulings
  In order to fill all shifts and solve organizational problems
  As an employee
  I want to comment on schedulings

  Background:
    Given today is 2012-12-18
      And the situation of a nuclear reactor
      And the employee "Homer" was scheduled in the plan as following:
        | date       | quickie |
        | 2012-12-21 | 7-23    |

  Scenario: planner writes the first comment
    Given I am on the page for the plan
     When I click on cell "Freitag"/"Homer S"
      And I wait for the modal box to appear
      And I follow "Kommentare" within the modal box
      And I fill in "Kommentar" with "Excellent!"
      And I press "Kommentieren"
     Then the "Kommentar" field should be empty
      And I should see "Excellent!" within comments within the modal box
      And I should see "Planner Burns" within comments within the modal box

  Scenario: employee answers
    Given a scheduling should exist
      And employee "Burns" has commented the scheduling with "Excellent!"
      And I sign out
      And I sign in as the user "Homer"
     When I go to the page for the plan
      And I click on cell "Freitag"/"Homer S"
      And I wait for the modal box to appear
     Then the "Kommentare" tab should be active
      And the "Kommentar" field should be empty
      And I should see "Excellent!" within comments within the modal box
      And I should see "Planner Burns" within comments within the modal box
     When I follow "Antworten"
      And I fill in "Kommentar" with "D'ooh!"
      And I press "Antworten"
     Then the "Kommentar" field should be empty
      And I should see "D'ooh!" within replies within comments within the modal box
      And I should see "Homer S" within replies within comments within the modal box
      But I should not see "Antworten" within "button"
