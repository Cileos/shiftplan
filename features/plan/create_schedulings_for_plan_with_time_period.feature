@javascript
Feature: Creating schedulings in a plan with time period

  Background:
    Given today is 2012-02-01
      # monday
      And the situation of a nuclear reactor


  # Show appropriate error message when user tries to create a scheduling with an hour
  # range over midnight resulting in the second scheduling being outside the plan's time
  # period. (When entering 22-6 for monday normally two schedulings would be created. 1st
  # monday 22-24.  2nd tuesday 0-6 which is outside the plan's time period in the
  # following scenario).
  Scenario: display error message when creating schedulings with next day outside the plan period
    # 2012-01-01: sunday
    # 2012-01-02: monday
    Given a plan exists with starts_at: "2012-01-01", ends_at: "2012-01-02", organization: the organization
      And I am on the employees in week page for the plan for week: 1, cwyear: 2012

     When I click on cell "Mo"/"Carl C"
      And I wait for the new scheduling form to appear
      And I fill in "Quickie" with "22-6"
      And I press "Anlegen"

     Then I should see "Der nächste Tag endet nach der Endzeit des Plans."
      And I should see the following calendar:
        | Mitarbeiter  | Mo   | Di  | Mi  | Do  | Fr  | Sa  | So  |
        | Carl C       |      |     |     |     |     |     |     |
        | Lenny L      |      |     |     |     |     |     |     |
        | Homer S      |      |     |     |     |     |     |     |
      And 0 schedulings should exist

  Scenario: click outside plan period does not open modal box
     Given a plan exists with starts_at: "2012-01-01", ends_at: "2012-01-02", organization: the organization
       And I am on the employees in week page for the plan for week: 1, cwyear: 2012

      When I click on a cell outside the plan period
      Then the new scheduling form should not appear

      When I click on a cell inside the plan period
      Then the new scheduling form should appear

  Scenario: only days within the plan period should be selectable in the new scheduling form
     # 2012-01-01: sunday
     # 2012-01-03: tuesday
     Given a plan exists with starts_at: "2012-01-01", ends_at: "2012-01-03", organization: the organization
       And I am on the employees in week page for the plan for week: 1, cwyear: 2012

      When I click on cell "Mo"/"Carl C"
      Then the new scheduling form should appear
       And the select field for "Wochentag" should have the following options:
        | Montag      |
        | Dienstag    |
       And I close the modal box

       And I inject style "position:relative" into "header"
      When I follow "<"
       And I click on cell "So"/"Carl C"
      Then the new scheduling form should appear
       And the select field for "Wochentag" should have the following options:
        | Sonntag     |
       And I close the modal box

       And I inject style "position:relative" into "header"
      When I follow "Neue Terminierung"
      Then the new scheduling form should appear
       And the select field for "Wochentag" should have the following options:
        | Sonntag     |
