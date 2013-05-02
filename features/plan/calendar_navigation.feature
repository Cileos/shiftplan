@big_screen
@javascript
Feature: Calendar navigation
  As a user I want to navigate weekly back and forth
  In order to browse through all schedulings of my plan

  Background:
    Given the situation of a nuclear reactor

  # In ISO8601, the week with January 4th is the first calendar week.  In 2016,
  # January 4th is a monday. Therefore the year 2016 is an edge case; the first
  # calendar week for the year 2016 is from monday, January 4th to sunday,
  # January 10th.
  Scenario Outline: Navigating back and forth weekwis, including between the years 2015 and 2016
    Given today is 2015-12-29
      And I am signed in as the confirmed user "Burns"
      And I go to the page of the plan
     Then I should be on the employees in week page of the plan for cwyear: 2015, week: 53
      And I should see "KW 53 / 2015" within active week
      And I should see "28.12." within weeks first date

     When I go to the <view> page of the plan for cwyear: 2015, week: 53
      And I should see "KW 53 / 2015" within active week
      And I should see "28.12" within weeks first date

      And I inject style "position:relative" into "header"
     When I follow ">" within the toolbar
     Then I should be on the <view> page of the plan for cwyear: 2016, week: 1
      And I should see "KW 01 / 2016" within active week
      And I should see "04.01." within weeks first date

      And I inject style "position:relative" into "header"
     When I follow "Heute" within the toolbar
     Then I should be on the <view> page of the plan for cwyear: 2015, week: 53
      And I should see "KW 53 / 2015" within active week
      And I should see "28.12." within weeks first date

     When I go to the <view> page of the plan for cwyear: 2016, week: 1
      And I should see "KW 01 / 2016" within active week
      And I should see "04.01." within weeks first date

      And I inject style "position:relative" into "header"
     When I follow "<" within the toolbar
     Then I should be on the <view> page of the plan for cwyear: 2015, week: 53
      And I should see "KW 53 / 2015" within active week
      And I should see "28.12." within weeks first date

      And I inject style "position:relative" into "header"
     When I follow "<" within the toolbar
     Then I should be on the <view> page of the plan for cwyear: 2015, week: 52
      And I should see "KW 52 / 2015" within active week
      And I should see "21.12." within weeks first date

    Examples:
      | view              |
      | employees in week |
      | teams in week     |
      | hours in week     |


  # In ISO8601, the week with January 4th is the first calendar week.  In 2015,
  # January 4th is a sunday. The first calendar week for the year 2015 is from
  # monday, December 29th to sunday, January 4th.
  Scenario Outline: Navigating back and forth weekwise between the years 2014 and 2015
    Given today is 2014-12-29
      And I am signed in as the confirmed user "Burns"
      And I go to the page of the plan
     Then I should be on the employees in week page of the plan for cwyear: 2015, week: 1
      And I should see "KW 01 / 2014" within active week
      And I should see "29.12." within weeks first date

     When I go to the <view> page of the plan for cwyear: 2015, week: 1
      And I should see "KW 01 / 2014" within active week
      And I should see "29.12." within weeks first date

      And I inject style "position:relative" into "header"
     When I follow "<" within the toolbar
     Then I should be on the <view> page of the plan for cwyear: 2014, week: 52
      And I should see "KW 52 / 2014" within active week
      And I should see "22.12." within weeks first date

      And I inject style "position:relative" into "header"
     When I follow "Heute" within the toolbar
     Then I should be on the <view> page of the plan for cwyear: 2015, week: 1
      And I should see "KW 01 / 2014" within active week
      And I should see "29.12." within weeks first date

    Examples:
      | view              |
      | employees in week |
      | teams in week     |
      | hours in week     |

  # no day view yet
  @wip
  Scenario: Navigating back and forth daywise
    Given I go to the teams in day page of the plan for year: 2015, month: 12, day: 31
      And I inject style "position:relative" into "header"
      And I follow ">" within the toolbar
     Then I should be on the teams in day page of the plan for year: 2016, month: 1, day: 01
      And I inject style "position:relative" into "header"
     When I follow "Heute" within the toolbar
     Then I should be on the teams in day page of the plan for year: 2015, month: 12, day: 31


  Scenario: the calendar navigation toolbar locks the user in the plan period
    Given today is 2012-02-01
      And I am signed in as the confirmed user "Burns"
      And I am on the page for the organization "Reactor"
     When I choose "Alle Pläne" from the drop down "Pläne"
      And I inject style "position:relative" into "header"
      And I follow "Hinzufügen"
      And I wait for the modal box to appear
      And I fill in "Name" with "Halloween im Atomkraftwerk"
     When I fill in "Startdatum" with "2012-01-01"
      And I fill in "Enddatum" with "2012-01-02"
      And I close all datepickers
      And I press "Anlegen"
      And I wait for the modal box to disappear
     Then a plan should exist with organization: the organization, name: "Halloween im Atomkraftwerk"

     When I follow "Halloween im Atomkraftwerk"
     # as today is after the plan period end the user gets redirected to the last week
     # view of the plan period (week 1, year 2012)
     Then I should be on the employees in week page for the plan for week: 1, cwyear: 2012
      And I should see "<" within the toolbar
      But I should not see ">" within the toolbar

      And I inject style "position:relative" into "header"
     When I follow "<" within the toolbar
     # in Germany, the week with january 4th is the first calendar week
     # in 2012, the January 1st is a sunday, so January 1st is in week 52 (of year 2011)
     Then I should be on the employees in week page for the plan for week: 52, cwyear: 2011
      And I should see ">" within the toolbar
      But I should not see "<" within the toolbar
      And I inject style "position:relative" into "header"
     When I follow ">" within the toolbar
     Then I should be on the employees in week page for the plan for week: 1, cwyear: 2012


