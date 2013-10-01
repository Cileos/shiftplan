@javascript
Feature: Creating schedulings in a plan with time period
  In order to limit the amount of work done on a project
  As a planner
  I want to create schedulings only within the specified period of a plan

  Background:
    Given the situation of a nuclear reactor
      # 2012-01-01: sunday
      # 2012-01-02: monday
      And a plan exists with starts_at: "2012-01-01", ends_at: "2012-01-02", organization: the organization
      And I am on the employees in week page for the plan for week: 1, cwyear: 2012


  # Show appropriate error message when user tries to create a scheduling with an hour
  # range over midnight resulting in the second scheduling being outside the plan's time
  # period.
  Scenario: display error message when creating schedulings with next day outside the plan period
     When I click on cell "Mo"/"Carl C"
      And I wait for the new scheduling form to appear
      And I schedule "22-6"
      And I press "Anlegen"

     Then I should see flash alert "Der nächste Tag endet nach der Endzeit des Plans."
      And I should see the following partial calendar:
        | Mitarbeiter    | Mo  | Di  | Mi  | Do  | Fr  | Sa  | So  |
        | Planner Burns  |     |     |     |     |     |     |     |
        | Carl C         |     |     |     |     |     |     |     |
        | Lenny L        |     |     |     |     |     |     |     |
        | Homer S        |     |     |     |     |     |     |     |
      And 0 schedulings should exist

  Scenario: click outside plan period does not open modal box
      When I click on a cell outside the plan period
      Then the new scheduling form should not appear

      When I click on a cell inside the plan period
      Then the new scheduling form should appear
