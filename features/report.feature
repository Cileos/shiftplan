Feature: create a report for account owner
  In order to keep an overviews of the schedulings
  As an owner of the account with 2 organizations each 2 plans each 2 scheduling
  I want to see the created schedulings of all organizations and plans in an report

  Background:
    Given the situation of a nuclear reactor

  Scenario:
    Given a plan "shut down" exists with organization: organization "Reactor"
    And the employee "Lenny" was scheduled in the plan "shut down" as following:
        | date       | quickie |
        | 2012-12-21 | 7-23:15 |
    And the employee "Homer" was scheduled in the plan "shut down" as following:
        | date       | quickie |
        | 2012-12-21 | 8-23:15 |
    And the employee "Lenny" was scheduled in the plan "clean reactor" as following:
        | date       | quickie |
        | 2013-01-15 | 7-23:15 |
    And the employee "Homer" was scheduled in the plan "clean reactor" as following:
        | date       | quickie |
        | 2013-01-21 | 7-23:15 |
        | 2013-01-22 | 7-23:15 |
    And I choose "Report" from the drop down "Info"
    And I should see the following table of reports:
      | Datum                   | Anzahl der Stunden | Name     | Team | Plan                 |
      | 22.01.2013 um 07:00 Uhr | 16:15              | S, Homer |      | Cleaning the Reactor |
      | 21.01.2013 um 07:00 Uhr | 16:15              | S, Homer |      | Cleaning the Reactor |
      | 15.01.2013 um 07:00 Uhr | 16:15              | L, Lenny |      | Cleaning the Reactor |
      | 21.12.2012 um 08:00 Uhr | 15:15              | S, Homer |      | Egon's 1st Plan      |
      | 21.12.2012 um 07:00 Uhr | 16:15              | L, Lenny |      | Egon's 1st Plan      |

