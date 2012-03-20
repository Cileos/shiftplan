@javascript
Feature: Comment on Schedulings
  In order to fill all shifts and solve organizational problems
  As an employee
  I want to comment on schedulings

  Background:
    Given today is 2012-12-18
      And the situation of a nuclear reactor

  Scenario: writing the first comment
    Given the employee "Homer" was scheduled in the plan as following:
        | date       | quickie |
        | 2012-12-21 | 7-23    |
      And I am on the page for the plan
     When I click on cell "Freitag"/"Homer S"
      And I follow "Kommentare" within the modal box
      And I fill in "Kommentar" with "Excellent!"
      And I press "Abschicken"
     Then I should see "Excellent!" within the modal box
