@javascript
Feature: Calendar navigation
  As a user I want to navigate weekly back and forth
  In order to browse through all schedulings of my plan

  Background:
    Given the situation of a nuclear reactor

  # In Germany, the week with January 4th is the first calendar week.
  # In 2016, January 4th is a monday. Therefore the year 2016 is an edge case for the
  # calendar navigation and is tested here. The first calendar week for the year 2016
  # is from monday, January 4th to sunday, January 10th.
  Scenario Outline: Navigating back and forth weekwise between the years 2015 and 2016
    Given today is 2015-12-29
      And I am signed in as the confirmed user "Burns"
      And I go to the page of the plan
     Then I should be on the employees in week page of the plan for year: 2015, week: 53
      And I should see "KW 53 28.12.2015"

     When I go to the <view> page of the plan for year: 2015, week: 53
      And I should see "KW 53 28.12.2015"

     When I follow ">" within the toolbar
     Then I should be on the <view> page of the plan for year: 2016, week: 1
      And I should see "KW 01 04.01.2016"

     When I follow "Heute" within the toolbar
     Then I should be on the <view> page of the plan for year: 2015, week: 53
      And I should see "KW 53 28.12.2015"

     When I go to the <view> page of the plan for year: 2016, week: 1
      And I should see "KW 01 04.01.2016"

     When I follow "<" within the toolbar
     Then I should be on the <view> page of the plan for year: 2015, week: 53
      And I should see "KW 53 28.12.2015"

     When I follow "<" within the toolbar
     Then I should be on the <view> page of the plan for year: 2015, week: 52
      And I should see "KW 52 21.12.2015"

    Examples:
      | view              |
      | employees in week |
      | teams in week     |
      | hours in week     |


  # In Germany, the week with January 4th is the first calendar week.
  # In 2015, January 4th is a sunday. Therefore the year 2015 is an edge case for the
  # calendar navigation and is tested here. The first calendar week for the year 2015
  # is from monday, December 29th to sunday, January 4th.
  Scenario Outline: Navigating back and forth weekwise between the years 2014 and 2015
    Given today is 2014-12-29
      And I am signed in as the confirmed user "Burns"
      And I go to the page of the plan
     Then I should be on the employees in week page of the plan for year: 2015, week: 1
      And I should see "KW 01 29.12.2014"

     When I go to the <view> page of the plan for year: 2015, week: 1
      And I should see "KW 01 29.12.2014"

     When I follow "<" within the toolbar
     Then I should be on the <view> page of the plan for year: 2014, week: 52
      And I should see "KW 52 22.12.2014"

     When I follow "Heute" within the toolbar
     Then I should be on the <view> page of the plan for year: 2015, week: 1
      And I should see "KW 01 29.12.2014"

    Examples:
      | view              |
      | employees in week |
      | teams in week     |
      | hours in week     |

  @wip
  Scenario: Navigating back and forth daywise
    Given I go to the teams in day page of the plan for year: 2015, month: 12, day: 31
      And I follow ">" within the toolbar
     Then I should be on the teams in day page of the plan for year: 2016, month: 1, day: 01
     When I follow "Heute" within the toolbar
     Then I should be on the teams in day page of the plan for year: 2015, month: 12, day: 31


  Scenario: the calendar navigation toolbar locks the user in the plan period
    Given today is 2012-02-01
      And I am signed in as the confirmed user "Burns"
      And I am on the page for the organization "Reactor"
     When I choose "Alle Pläne" from the drop down "Pläne"
      And I follow "Hinzufügen"
      And I wait for the modal box to appear
      And I fill in "Name" with "Halloween im Atomkraftwerk"
     When I fill in "Startdatum" with "2012-01-01"
      And I fill in "Enddatum" with "2012-01-02"
      And I press "Anlegen"
      And I wait for the modal box to disappear
     Then a plan should exist with organization: the organization, name: "Halloween im Atomkraftwerk"

     When I follow "Halloween im Atomkraftwerk"
     # as today is after the plan period end the user gets redirected to the last week
     # view of the plan period (week 1, year 2012)
     Then I should be on the employees in week page for the plan for week: 1, year: 2012
      And I should see "<" within the toolbar
      But I should not see ">" within the toolbar

     When I follow "<" within the toolbar
     # in Germany, the week with january 4th is the first calendar week
     # in 2012, the January 1st is a sunday, so January 1st is in week 52 (of year 2011)
     Then I should be on the employees in week page for the plan for week: 52, year: 2011
      And I should see ">" within the toolbar
      But I should not see "<" within the toolbar
     When I follow ">" within the toolbar
     Then I should be on the employees in week page for the plan for week: 1, year: 2012


  # a basic version of this is tested in every plan/view_*week.feature
  Scenario: Navigation weekly back and forth
    Given today is 2012-12-04
      And I am signed in as the confirmed user "Burns"
      And the employee "Homer" was scheduled in the plan as following:
        | week | cwday | quickie |
        | 48   | 1     | 9-17    |
        | 49   | 2     | 10-16   |
        | 50   | 3     | 11-15   |
        | 51   | 4     | 12-14   |

     When I go to the page of the plan
     Then I should be on the employees in week page of the plan for week: 49, year: 2012
      And I should see a calendar titled "Cleaning the Reactor - KW 49 03.12.2012"
      And I should see the following calendar:
        | Mitarbeiter   | Mo | Di    | Mi | Do | Fr |
        | Carl C        |    |       |    |    |    |
        | Lenny L       |    |       |    |    |    |
        | Homer S       |    | 10-16 |    |    |    |

     When I follow "<" within the toolbar
     Then I should be on the employees in week page of the plan for week: 48, year: 2012
      And I should see a calendar titled "Cleaning the Reactor - KW 48 26.11.2012"
      And I should see the following calendar:
        | Mitarbeiter   | Mo   | Di | Mi | Do | Fr |
        | Carl C        |      |    |    |    |    |
        | Lenny L       |      |    |    |    |    |
        | Homer S       | 9-17 |    |    |    |    |

     When I follow ">" within the toolbar
     Then I should be on the employees in week page of the plan for week: 49, year: 2012
      And I should see a calendar titled "Cleaning the Reactor - KW 49 03.12.2012"
      And I should see the following calendar:
        | Mitarbeiter   | Mo | Di    | Mi | Do | Fr |
        | Carl C        |    |       |    |    |    |
        | Lenny L       |    |       |    |    |    |
        | Homer S       |    | 10-16 |    |    |    |

     When I follow ">" within the toolbar
     Then I should be on the employees in week page of the plan for week: 50, year: 2012
      And I should see a calendar titled "Cleaning the Reactor - KW 50 10.12.2012"
      And I should see the following calendar:
        | Mitarbeiter   | Mo | Di | Mi    | Do | Fr |
        | Carl C        |    |    |       |    |    |
        | Lenny L       |    |    |       |    |    |
        | Homer S       |    |    | 11-15 |    |    |

     When I follow ">" within the toolbar
     Then I should be on the employees in week page of the plan for week: 51, year: 2012
      And I should see a calendar titled "Cleaning the Reactor - KW 51 17.12.2012"
      And I should see the following calendar:
        | Mitarbeiter   | Mo | Di | Mi | Do    | Fr |
        | Carl C        |    |    |    |       |    |
        | Lenny L       |    |    |    |       |    |
        | Homer S       |    |    |    | 12-14 |    |
