@javascript
Feature: Typeahead autocompletion for Quickies
  In order to save typing and eleminate typos
  As a Planner
  I want to get suggestions based on the schedulings I already entered

  Background:
    Given today is 2012-12-04
      And the situation of a nuclear reactor

  Scenario: Completion by start hour
    Given the employee "Homer" was scheduled in the plan as following:
        | week | cwday | quickie |
        | 49   | 3     | 9-17    |
      And I am on the employees in week page for the plan for year: 2012, week: 49
     When I click on cell "Mo"/"Homer S"
      And I wait for the modal box to appear
      And I fill in "Quickie" with "9"
      And I press return in the "Quickie" field
     Then the "Quickie" field should contain "9-17"
