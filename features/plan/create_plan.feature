@javascript
Feature: Creating a plan
  In order to schedule work in my organization
  As a planner
  I want to create a plan

  Background:
    Given today is 2012-02-01
      # 2012-02-01 is a wednesday
      And the situation of a nuclear reactor

  Scenario: creating a plan by name for the current organization
    Given I am on the page for the organization "Reactor"
     When I choose "Alle Pläne" from the drop down "Pläne"
      And I follow "Hinzufügen"
      And I wait for the modal box to appear
      And I fill in "Name" with "Halloween im Atomkraftwerk"
     When I fill in "Beschreibung" with "5 eyes minimum"
      And I press "Anlegen"
      And I wait for the modal box to disappear

     Then I should see the following table of plans:
        | Name                        | Beschreibung    | Startdatum  | Enddatum  |
        | Cleaning the Reactor        |                 | -           | -         |
        | Halloween im Atomkraftwerk  | 5 eyes minimum  | -           | -         |
      And a plan should exist with organization: the organization, name: "Halloween im Atomkraftwerk"

     When I follow "Halloween im Atomkraftwerk"
     Then I should be on the employees in week page for the plan for week: 5, year: 2012
      And the page should be titled "Halloween im Atomkraftwerk"
      And I should see "5 eyes minimum"
      And I should see a calendar titled "Halloween im Atomkraftwerk"
      And I should see "KW 05 / 2012" within active week
      And I should see "30.01." within weeks first date
      And I should see the following calendar:
        | Mitarbeiter   | Mo | Di | Mi | Do | Fr | Sa | So |
        | Carl C        |    |    |    |    |    |    |    |
        | Lenny L       |    |    |    |    |    |    |    |
        | Homer S       |    |    |    |    |    |    |    |


  Scenario: plan's start time must be smaller or equal to the plan's end time
    Given I am on the page for the organization "Reactor"
     When I choose "Alle Pläne" from the drop down "Pläne"
      And I follow "Hinzufügen"
      And I wait for the modal box to appear
      And I fill in "Name" with "Halloween im Atomkraftwerk"
      And I fill in "Beschreibung" with "Halloween im Atomkraftwerk"
      And I fill in "Startdatum" with "2012-01-02"
      And I fill in "Enddatum" with "2012-01-01"
      And I close all datepickers
      And I press "Anlegen"
     Then I should see "Das Startdatum muss kleiner oder gleich dem Enddatum des Plans sein" within errors
      And 0 plans should exist with name: "Halloween im Atomkraftwerk"


  # in germany, the week with january 4th is the first calendar week
  # in 2012, the January 1st is a sunday, so January 1st is in week 52 (of year 2011)
  Scenario: user gets redirected properly to last cweek of the previous year for 2012-01-01
    Given today is 2011-12-15
      And I am on the page for the organization "Reactor"
     When I choose "Alle Pläne" from the drop down "Pläne"
      And I follow "Hinzufügen"
      And I wait for the modal box to appear
      And I fill in "Name" with "Halloween im Atomkraftwerk"
     When I fill in "Startdatum" with "2012-01-01"
      And I fill in "Enddatum" with "2012-01-28"
      And I close all datepickers
      And I press "Anlegen"
      And I wait for the modal box to disappear
     Then a plan should exist with organization: the organization, name: "Halloween im Atomkraftwerk"

     When I follow "Halloween im Atomkraftwerk"
     # as today is before the plan period end the user gets redirected to the first week
     # view of the plan period (week 52, year 2011)
     Then I should be on the employees in week page for the plan for week: 52, year: 2011


  Scenario: user is locked within the plan period frame when trying to visit a page outside the frame
    # 2012-02-27: monday, 9th calendar week
    # 2012-03-30: friday, 13th calendar week
    Given a plan exists with starts_at: "2012-02-27", ends_at: "2012-03-30", organization: the organization
      And I go to the page of the plan
     Then I should be on the employees in week page for the plan for week: 9, year: 2012

     When I go to the employees in week page for the plan for week: 14, year: 2012
     # user gets redirected to last page of the plan period
     Then I should be on the employees in week page for the plan for week: 13, year: 2012

     When I go to the employees in week page for the plan for week: 8, year: 2012
     # user gets redirected to first page of the plan period
     Then I should be on the employees in week page for the plan for week: 9, year: 2012

     When I go to the employees in week page for the plan for week: 13, year: 2012
     Then I should be on the employees in week page for the plan for week: 13, year: 2012


  Scenario: focus first calendar cell which is not outside the plan period
     # 2012-01-03: tuesday
     # 2012-01-04: wednesday
     Given a plan exists with starts_at: "2012-01-03", ends_at: "2012-01-04", organization: the organization
       And I go to the page of the plan
      Then I should be on the employees in week page for the plan for week: 1, year: 2012
      And the cell "Di"/"Carl C" should be focus
