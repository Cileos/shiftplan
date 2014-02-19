Feature: Report
  In order to keep an overview of the schedulings
  As an employee
  I want to see a list of all the schedulings of the organization

  Background:
    Given the situation of a nuclear reactor

  Scenario:
    Given a organization "PR" exist with account: the account
    And a plan "lie to the public" exists with organization: organization "PR"
    And a plan "shut down" exists with organization: organization "Reactor"
    And a team exists with name: "Uran rangieren", organization: organization: "Reactor"
    Then the employee "Lenny" was scheduled in the plan "lie to the public" as following:
        | date       | quickie |
        | 2012-12-21 | 7-14:30 |
    Then the employee "Lenny" was scheduled in the plan "shut down" as following:
        | date       | quickie                  |
        | 2012-12-21 | 7-14:30  Uran rangieren  |
    And the employee "Homer" was scheduled in the plan "shut down" as following:
        | date       | quickie |
        | 2012-12-21 | 8-16:30 |
    And the employee "Lenny" was scheduled in the plan "clean reactor" as following:
        | date       | quickie |
        | 2013-01-15 | 7-14:30 |
    And I choose "Report" from the drop down "Info"
    And I should see the following table of reports:
      | Datum                    | Stunden  | Name      | Team            | Plan                  |
      | 15.01.2013 um 07:00 Uhr  | 7:30     | L, Lenny  |                 | Cleaning the Reactor  |
      | 21.12.2012 um 08:00 Uhr  | 8:30     | S, Homer  |                 | Egon's 2nd Plan       |
      | 21.12.2012 um 07:00 Uhr  | 7:30     | L, Lenny  | Uran rangieren  | Egon's 2nd Plan       |
