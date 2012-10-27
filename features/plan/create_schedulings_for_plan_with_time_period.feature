@javascript
Feature: Creating schedulings in a plan with time period

  Background:
    Given today is 2012-02-01
      # monday
      And the situation of a nuclear reactor


  Scenario: schedulings within the plan's time period can be created
    Given I am on the page for the organization "Reactor"
     When I choose "Alle Pläne" from the drop down "Pläne"
      And I follow "Hinzufügen"
      And I wait for the modal box to appear
      And I fill in "Name" with "Halloween im Atomkraftwerk"
      # sunday
     When I fill in "Startdatum" with "2012-01-01"
      # tuesday
      And I fill in "Enddatum" with "2012-01-03"
      And I close all datepickers
      And I press "Anlegen"
      And I wait for the modal box to disappear
     Then I should see the following table of plans:
        | Name                        | Beschreibung  | Startdatum  | Enddatum    |
        | Cleaning the Reactor        |               | -           | -           |
        | Halloween im Atomkraftwerk  |               | 01.01.2012  | 03.01.2012  |
      And a plan should exist with organization: the organization, name: "Halloween im Atomkraftwerk"

     When I follow "Halloween im Atomkraftwerk"
     # as today is after the plan period end the user gets redirected to the last week
     # view of the plan period (week 1, year 2012)
     Then I should be on the employees in week page for the plan for week: 1, year: 2012

     When I click on cell "Mo"/"Carl C"
      And I wait for the new scheduling form to appear
      And I fill in "Quickie" with "9-17"
      And I press "Anlegen"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
        | Mitarbeiter  | Mo   | Di  | Mi  | Do  | Fr  | Sa  | So  |
        | Carl C       | 9-17 |     |     |     |     |     |     |
        | Lenny L      |      |     |     |     |     |     |     |
        | Homer S      |      |     |     |     |     |     |     |

    When I click on cell "Mo"/"Carl C"
     And I wait for the new scheduling form to appear
     And I fill in "Quickie" with "22-6"
     And I press "Anlegen"
     And I wait for the modal box to disappear
     Then I should see the following calendar:
        | Mitarbeiter  | Mo          | Di   | Mi  | Do  | Fr  | Sa  | So  |
        | Carl C       | 9-17 22-24  | 0-6  |     |     |     |     |     |
        | Lenny L      |             |      |     |     |     |     |     |
        | Homer S      |             |      |     |     |     |     |     |

     # check if scheduling is still displayed after revisiting the page
     When I follow "<" within the toolbar
     When I follow ">" within the toolbar
     Then I should see the following calendar:
        | Mitarbeiter  | Mo          | Di   | Mi  | Do  | Fr  | Sa  | So  |
        | Carl C       | 9-17 22-24  | 0-6  |     |     |     |     |     |
        | Lenny L      |             |      |     |     |     |     |     |
        | Homer S      |             |      |     |     |     |     |     |


  # When creating schedulings with an hour range over midnight and turn of year (special case)
  # we have to make sure that for both schedulings that will be created (1st 22:00-23:59, 2nd 0:00-6:00)
  # the year and week will be set the right way. In the case of Sunday, 2012-01-01
  # 22:00-23:59 the year must be set to 2011 and the week to the calendar week 52 as Jan
  # 1st 2012 belongs to the last week in 2011. Otherwise the scheduling filter will not
  # fetch the scheduling when visiting the page for week 52, year 2011.
  # For the second scheduling (0:00-6:00 2012-01-02) the week must be set to 1 and year to
  # 2012.
  Scenario: creating schedulings with an hour range over midnight and turn of calendar week and year (special case)
    # 2012-01-01: sunday
    # 2012-01-02: monday
    Given a plan exists with starts_at: "2012-01-01", ends_at: "2012-01-02", organization: the organization
      And I go to the page of the plan
     Then I should be on the employees in week page for the plan for week: 1, year: 2012
     When I follow "<"
      And I click on cell "So"/"Carl C"
      And I wait for the new scheduling form to appear
      And I fill in "Quickie" with "22-6"
      And I press "Anlegen"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
        | Mitarbeiter  | Mo  | Di  | Mi  | Do  | Fr  | Sa  | So      |
        | Carl C       |     |     |     |     |     |     | 22-24   |
        | Lenny L      |     |     |     |     |     |     |         |
        | Homer S      |     |     |     |     |     |     |         |
     When I follow ">"
     Then I should see the following calendar:
        | Mitarbeiter  | Mo     | Di  | Mi  | Do  | Fr  | Sa  | So  |
        | Carl C       | 0-6    |     |     |     |     |     |     |
        | Lenny L      |        |     |     |     |     |     |     |
        | Homer S      |        |     |     |     |     |     |     |
     # go back to first page to really make sure that scheduling filter will fetch
     # the scheduling so that it will be displayed in the calendar week.
     When I follow "<"
     Then I should see the following calendar:
        | Mitarbeiter  | Mo  | Di  | Mi  | Do  | Fr  | Sa  | So      |
        | Carl C       |     |     |     |     |     |     | 22-24   |
        | Lenny L      |     |     |     |     |     |     |         |
        | Homer S      |     |     |     |     |     |     |         |


  # Show appropriate error message when user tries to create a scheduling with an hour
  # range over midnight resulting in the second scheduling being outside the plan's time
  # period. (When entering 22-6 for monday normally two schedulings would be created. 1st
  # monday 22-24.  2nd tuesday 0-6 which is outside the plan's time period in the
  # following scenario).
  Scenario: display error message when creating schedulings with next day outside the plan period
    # 2012-01-01: sunday
    # 2012-01-02: monday
    Given a plan exists with starts_at: "2012-01-01", ends_at: "2012-01-02", organization: the organization
      And I go to the page of the plan
     Then I should be on the employees in week page for the plan for week: 1, year: 2012

     When I click on cell "Mo"/"Carl C"
      And I wait for the new scheduling form to appear
      And I fill in "Quickie" with "22-6"
      And I press "Anlegen"

     Then I should see "Die Endzeit ist größer als die Endzeit des Plans."
      And I should see the following calendar:
        | Mitarbeiter  | Mo   | Di  | Mi  | Do  | Fr  | Sa  | So  |
        | Carl C       |      |     |     |     |     |     |     |
        | Lenny L      |      |     |     |     |     |     |     |
        | Homer S      |      |     |     |     |     |     |     |
      And 0 schedulings should exist


  Scenario: no modals boxes open when clicking on cells which are outside the plan period in employees in week view
    # 2012-01-01: sunday
    # 2012-01-02: monday
    Given a plan exists with starts_at: "2012-01-01", ends_at: "2012-01-02", organization: the organization
      And I go to the page of the plan
     Then I should be on the employees in week page for the plan for week: 1, year: 2012

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


  Scenario: no modals boxes open when clicking on cells which are outside the plan period in teams in week view
      Given a team exist with name: "Reaktor fegen", organization: the organization
       # 2012-01-01: sunday
       # 2012-01-02: monday
       And a plan exists with starts_at: "2012-01-01", ends_at: "2012-01-02", organization: the organization
       And I go to the page of the plan
      Then I should be on the employees in week page for the plan for week: 1, year: 2012

      When I choose "Teams" from the drop down "Mitarbeiter" within the calendar

      When I click on cell "Mo"/"Reaktor fegen"
      Then the new scheduling form should appear
       And I close the modal box

      When I click on cell "Di"/"Reaktor fegen"
      Then the new scheduling form should not appear



  Scenario: no modals boxes open when clicking on cells which are outside the plan period in hours in week view
     # 2012-01-01: sunday
     # 2012-01-02: monday
     Given a plan exists with starts_at: "2012-01-01", ends_at: "2012-01-02", organization: the organization
       And I go to the page of the plan
      Then I should be on the employees in week page for the plan for week: 1, year: 2012

      When I choose "Stunden" from the drop down "Mitarbeiter" within the calendar

      When I click on cell "Mo"/"1"
      Then the new scheduling form should appear
       And I close the modal box

      When I click on cell "Di"/"1"
      Then the new scheduling form should not appear


  Scenario: only days within the plan period should be selectable in the new scheduling form
     # 2012-01-01: sunday
     # 2012-01-03: tuesday
     Given a plan exists with starts_at: "2012-01-01", ends_at: "2012-01-03", organization: the organization
       And I go to the page of the plan
      Then I should be on the employees in week page for the plan for week: 1, year: 2012

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
