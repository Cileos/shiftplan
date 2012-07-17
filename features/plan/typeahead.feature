@javascript
Feature: Typeahead autocompletion for Quickies
  In order to save typing and eleminate typos
  As a Planner
  I want to get suggestions based on the schedulings I already entered

  Background:
    Given today is 2012-12-04
      And the situation of a nuclear reactor

  Scenario: Completion by start hour pressing return
    Given the employee "Homer" was scheduled in the plan as following:
        | week | cwday | quickie |
        | 49   | 3     | 9-17    |
      And I am on the employees in week page for the plan for year: 2012, week: 49
     When I click on cell "Mo"/"Homer S"
      And I wait for the modal box to appear
      And I fill in "Quickie" with "9"
      And I press return in the "Quickie" field
     Then the "Quickie" field should contain "9-17"

  Scenario: Completion by start hour pressing return
    Given the employee "Homer" was scheduled in the plan as following:
        | week | cwday | quickie |
        | 49   | 3     | 9-17    |
      And I am on the employees in week page for the plan for year: 2012, week: 49
     When I click on cell "Mo"/"Homer S"
      And I wait for the modal box to appear
      And I fill in "Quickie" with "9"
      And I press tab in the "Quickie" field
     Then the "Quickie" field should contain "9-17"

  Scenario: Completion is selectable by arrow up/down
    Given the employee "Homer" was scheduled in the plan as following:
        | week | cwday | quickie                  |
        | 49   | 3     | 9-17 Reaktor ausschalten |
        | 49   | 4     | 9-17 Reaktor fegen       |
        | 49   | 5     | 9-17 Reaktor einschalten  |
      And I am on the employees in week page for the plan for year: 2012, week: 49
     When I click on cell "Mo"/"Homer S"
      And I wait for the modal box to appear
      And I fill in "Quickie" with "Reak"
     Then I should see the following typeahead items:
        | 9-17 Reaktor ausschalten [Ra] | active |
        | 9-17 Reaktor einschalten [Re] |        |
        | 9-17 Reaktor fegen [Rf]       |        |
     When I press arrow down in the "Quickie" field
     Then I should see the following typeahead items:
        | 9-17 Reaktor ausschalten [Ra] |        |
        | 9-17 Reaktor einschalten [Re] | active |
        | 9-17 Reaktor fegen [Rf]       |        |
     When I press arrow down in the "Quickie" field
      And I press tab in the "Quickie" field
     Then the "Quickie" field should contain "9-17 Reaktor fegen \[Rf\]"

     # cleans up
     When I press return in the "Quickie" field
      And I wait for the modal box to disappear
     Then the typeahead list should be removed from the dom
