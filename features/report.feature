Feature: create a report for account owner
  In order to keep an overviews of the schedulings
  As an owner of the account with 2 organizations each 2 plans each 2 scheduling
  I want to see the created schedulings of all organizations and plans in an report

  Background:
    Given the situation of a nuclear reactor

  Scenario:
    Given a organization "PR" exist with account: the account
    And a plan "shut down" exists with organization: organization "Reactor"
    And a plan "lie to the public" exists with organization: organization "PR"
    And a plan "sell nuclear energy" exists with organization: organization "PR"
    And the employee "Lenny" was scheduled in the plan "shut down" as following:
        | date       | quickie |
        | 2012-12-21 | 7-23:15 |
    And the employee "Homer" was scheduled in the plan "shut down" as following:
        | date       | quickie |
        | 2012-12-21 | 7-23:15 |
    And the employee "Lenny" was scheduled in the plan "clean reactor" as following:
        | date       | quickie |
        | 2013-01-15 | 7-23:15 |
    And the employee "Homer" was scheduled in the plan "clean reactor" as following:
        | date       | quickie |
        | 2013-01-21 | 7-23:15 |
        | 2013-01-22 | 7-23:15 |
    And the employee "Carl" was scheduled in the plan "lie to the public" as following:
        | date       | quickie |
        | 2013-02-04 | 7-23:15 |
    And the employee "Burns" was scheduled in the plan "lie to the public" as following:
        | date       | quickie  |
        | 2013-03-14 | 10-18:15 |
    And the employee "Burns" was scheduled in the plan "sell nuclear energy" as following:
        | date       | quickie  |
        | 2013-04-05 | 10-18:15 |
    And I choose "Report" from the drop down "Info"
    And I see a list of the following schedulings:
      | date       |
      | 21.12.2012 |
      | 21.12.2012 |
      | 15.01.2013 |
      | 21.01.2013 |
      | 22.01.2013 |
      | 04.02.2013 |
      | 14.03.2013 |
      | 05.04.2013 |

