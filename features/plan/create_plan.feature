@javascript
Feature: Creating a plan
  In order to schedule work in my organization
  As a planner
  I want to create a plan

  Background:
    # 2012-02-01 is a wednesday
    Given today is 2012-02-01

  Scenario: creating a plan by name for the current organization
    Given the situation of a nuclear reactor
      And I am on the page for the organization "Reactor"

     When I choose "Alle Pläne" from the drop down "Pläne"
      And I follow "Hinzufügen"
      And I wait for the modal box to appear
      And I fill in "Name" with "Halloween im Atomkraftwerk"
      And I fill in "Beschreibung" with "5 eyes minimum"

    Given I should not see "Enddatum" within the modal box
      And the "fortlaufend" checkbox should be checked
     When I choose "zeitlich beschränkt"
      And I pick "22. Dezember 2016" from "Enddatum"
     Then the "Enddatum" field should contain "22.12.2016"

     # values are kept within the form
     When I choose "fortlaufend"
      And I choose "zeitlich beschränkt"
     Then the "Enddatum" field should contain "22.12.2016"

     # clear field from within datepicker
     When I use the datepicker to clear "Enddatum"
     Then the "Enddatum" field should be empty

     # clear field from within datepicker
     When I pick "23. Dezember 2016" from "Enddatum"
      And I press "Anlegen"
      And I wait for the modal box to disappear

     Then I should see the following table of plans:
        | Name                       | Beschreibung   | Startdatum | Enddatum   |
        | Cleaning the Reactor       |                | -          | -          |
        | Halloween im Atomkraftwerk | 5 eyes minimum | -          | 23.12.2016 |
      And a plan should exist with organization: the organization, name: "Halloween im Atomkraftwerk"

     When I choose "Halloween im Atomkraftwerk" from the drop down "Pläne"
     Then I should be on the employees in week page for the plan for week: 5, cwyear: 2012
      And the page should be titled "Halloween im Atomkraftwerk"
      And I should see "5 eyes minimum"
      And I should see a calendar titled "Halloween im Atomkraftwerk"
      And I should see "KW 05 / 2012" within active week
      And I should see "30.01." within weeks first date


  Scenario: focus first calendar cell which is not outside the plan period
     Given the situation of a nuclear reactor
     # 2012-01-03: tuesday
     # 2012-01-04: wednesday
       And a plan exists with starts_at: "2012-01-03", ends_at: "2012-01-04", organization: the organization
       And I go to the page of the plan
      Then I should be on the employees in week page for the plan for week: 1, cwyear: 2012
       And the cell "Di"/"Planner Burns" should be focus
