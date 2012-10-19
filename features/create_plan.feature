@javascript
Feature: Creating a plan
  In order to schedule work in my organization
  As a planner
  I want to create a plan

  Background:
    Given today is 2012-02-01
      # monday
      And the situation of a nuclear reactor
      And I am on the page for the organization "Reactor"
      When I choose "Alle Pläne" from the drop down "Pläne"
      And I follow "Hinzufügen"
      And I wait for the modal box to appear
      And I fill in "Name" with "Halloween im Atomkraftwerk"

  Scenario: creating a plan by name for the current organization
     When I fill in "Beschreibung" with "5 eyes minimum"
      And I press "Anlegen"

     Then a plan should exist with organization: the organization, name: "Halloween im Atomkraftwerk"
      And I should be on the employees in week page for the plan for week: 5, year: 2012
      And the page should be titled "Halloween im Atomkraftwerk"
      And I should see "5 eyes minimum"
      And I should see a calendar titled "Halloween im Atomkraftwerk - KW 05 30.01.2012"
      And I should see the following calendar:
        | Mitarbeiter   | Mo | Di | Mi | Do | Fr | Sa | So |
        | Carl C        |    |    |    |    |    |    |    |
        | Lenny L       |    |    |    |    |    |    |    |
        | Homer S       |    |    |    |    |    |    |    |


  Scenario: when creating a plan with a time period the toolbar navigation locks the user in the plan period
     When I fill in "Startdatum" with "2012-01-01"
      And I fill in "Enddatum" with "2012-01-02"
      And I press "Anlegen"
     Then a plan should exist with organization: the organization, name: "Halloween im Atomkraftwerk"
     # as today is after the plan period end the user gets redirected to the last week
     # view of the plan period (week 1, year 2012)
      And I should be on the employees in week page for the plan for week: 1, year: 2012
      And I should see "<" within the toolbar
      But I should not see ">" within the toolbar

     When I follow "<" within the toolbar
     # in germany, the week with january 4th is the first calendar week
     # in 2012, the January 1st is a sunday, so January 1st is in week 52 (of year 2011)
     Then I should be on the employees in week page for the plan for week: 52, year: 2011
      And I should see ">" within the toolbar
      But I should not see "<" within the toolbar
     When I follow ">" within the toolbar
     Then I should be on the employees in week page for the plan for week: 1, year: 2012


  # in germany, the week with january 4th is the first calendar week
  # in 2012, the January 1st is a sunday, so January 1st is in week 52 (of year 2011)
  Scenario: user gets redirected properly to last cweek of the previous year for 2012-01-01
     When I fill in "Startdatum" with "2012-01-01"
      And I fill in "Enddatum" with "2012-01-01"
      And I press "Anlegen"
     Then a plan should exist with organization: the organization, name: "Halloween im Atomkraftwerk"
      And I should be on the employees in week page for the plan for week: 52, year: 2011
      And I should not see "<" within the toolbar
      And I should not see ">" within the toolbar


  Scenario: user is locked within the plan period frame when trying to visit a page outside the frame
      # monday 4 weeks from now (9th week, german)
     When I fill in "Startdatum" with "2012-02-27"
      # friday a month later (13th week, german)
      And I fill in "Enddatum" with "2012-03-30"
      And I press "Anlegen"
     Then a plan should exist with organization: the organization, name: "Halloween im Atomkraftwerk"
      And I should be on the employees in week page for the plan for week: 9, year: 2012

     # trying to navigate to a page after the end of the plan period
     When I go to the employees in week page for the plan for week: 14, year: 2012
     # user gets redirected to last page of the plan period
     Then I should be on the employees in week page for the plan for week: 13, year: 2012

     # trying to navigate to a page before the start of the plan period
     When I go to the employees in week page for the plan for week: 8, year: 2012
     # user gets redirected to first page of the plan period
     Then I should be on the employees in week page for the plan for week: 9, year: 2012

     # trying to navigate to a page within the plan period
     When I go to the employees in week page for the plan for week: 13, year: 2012
     Then I should be on the employees in week page for the plan for week: 13, year: 2012


  Scenario: no schedulings can be created for days outside the plan period in employees in week view
    # sunday
     When I fill in "Startdatum" with "2012-01-01"
     # monday
      And I fill in "Enddatum" with "2012-01-02"
      And I press "Anlegen"
     Then a plan should exist with organization: the organization, name: "Halloween im Atomkraftwerk"
      And I should be on the employees in week page for the plan for week: 1, year: 2012

      When I click on cell "Mo"/"Carl C"
      Then the new scheduling form should appear
       And I close the modal box

      When I click on cell "Di"/"Carl C"
      Then the new scheduling form should not appear

      When I follow "<" within the toolbar
      # in germany, the week with january 4th is the first calendar week
      # in 2012, the January 1st is a sunday, so January 1st is in week 52 (of year 2011)
      Then I should be on the employees in week page for the plan for week: 52, year: 2011

      When I click on cell "So"/"Carl C"
      Then the new scheduling form should appear
       And I close the modal box

      When I click on cell "Sa"/"Carl C"
      Then the new scheduling form should not appear

  Scenario: no schedulings can be created for days outside the plan period in teams in week view
     Given a team exist with name: "Reaktor fegen", organization: the organization
     # sunday
     When I fill in "Startdatum" with "2012-01-01"
      # monday
      And I fill in "Enddatum" with "2012-01-02"
      And I press "Anlegen"
     Then a plan should exist with organization: the organization, name: "Halloween im Atomkraftwerk"
      And I should be on the employees in week page for the plan for week: 1, year: 2012

      When I choose "Teams" from the drop down "Mitarbeiter" within the calendar

      When I click on cell "Mo"/"Reaktor fegen"
      Then the new scheduling form should appear
       And I close the modal box

      When I click on cell "Di"/"Reaktor fegen"
      Then the new scheduling form should not appear


  Scenario: no schedulings can be created for days outside the plan period in hours in week view
     # sunday
     When I fill in "Startdatum" with "2012-01-01"
      # monday
      And I fill in "Enddatum" with "2012-01-02"
      And I press "Anlegen"
     Then a plan should exist with organization: the organization, name: "Halloween im Atomkraftwerk"
      And I should be on the employees in week page for the plan for week: 1, year: 2012

      When I choose "Stunden" from the drop down "Mitarbeiter" within the calendar

      When I click on cell "Mo"/"0"
      Then the new scheduling form should appear
       And I close the modal box

      When I click on cell "Di"/"0"
      Then the new scheduling form should not appear


  Scenario: only days within the plan period should be selectable in the new scheduling form
    # sunday
     When I fill in "Startdatum" with "2012-01-01"
     # tuesday
      And I fill in "Enddatum" with "2012-01-03"
      And I press "Anlegen"
     Then a plan should exist with organization: the organization, name: "Halloween im Atomkraftwerk"
      And I should be on the employees in week page for the plan for week: 1, year: 2012

      When I click on cell "Mo"/"Carl C"
      Then the new scheduling form should appear
       And the select field for "Wochentag" should have the following options:
        | Montag      |
        | Dienstag    |
       And I close the modal box

      When I follow "<"
       And I click on cell "So"/"Carl C"
      Then the new scheduling form should appear
       And the select field for "Wochentag" should have the following options:
        | Sonntag     |
       And I close the modal box

      When I follow "Neue Terminierung"
      Then the new scheduling form should appear
       And the select field for "Wochentag" should have the following options:
        | Sonntag     |


  Scenario: focus first calendar cell which is not outside the plan period
    # tuesday
     When I fill in "Startdatum" with "2012-01-03"
     # wednesday
      And I fill in "Enddatum" with "2012-01-04"
      And I press "Anlegen"
     Then a plan should exist with organization: the organization, name: "Halloween im Atomkraftwerk"
      And I should be on the employees in week page for the plan for week: 1, year: 2012
      And the cell "Di"/"Carl C" should be focus
