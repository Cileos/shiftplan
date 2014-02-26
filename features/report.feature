Feature: Report
  In order to keep an overview of the schedulings
  As an employee
  I want to see a list of all the schedulings of the organization

  Background:
    Given the situation of a nuclear reactor

  Scenario:
    Given a organization "PR" exist with account: the account
    And a plan "lie to the public" exists with organization: organization "PR"
    And a plan "shut down" exists with organization: organization "Reactor", name: "Shut down"
    And a team "Uran rangieren" exists with organization: organization: "Reactor", name: "Uran rangieren"
    And a qualification exists with account: the account, name: "Brennstabpolierer"
    And the following schedulings exists:
     | date        | employee          | quickie  | plan                          | team                       | qualification      |
     | 2012-12-21  | employee "Lenny"  | 7-14:30  | the plan "lie to the public"  |                            |                    |
     | 2012-12-21  | employee "Lenny"  | 7-14:30  | the plan "shut down"          | the team "Uran rangieren"  | the qualification  |
     | 2012-12-21  | employee "Homer"  | 8-16:30  | the plan "shut down"          |                            |                    |
     | 2013-01-15  | employee "Lenny"  | 7-14:30  | the plan "clean reactor"      |                            |                    |

    And I choose "Reactor" from the drop down "Organisation"
    And I choose "Report" from the drop down "Info"
    And I should see the following table of reports:
      | Datum       | Stunden  | Name      | Team            | Qualifikation      | Plan                  | Organisation  |
      | 15.01.2013  | 7:30     | L, Lenny  |                 |                    | Cleaning the Reactor  | Reactor       |
      | 21.12.2012  | 8:30     | S, Homer  |                 |                    | Shut down             | Reactor       |
      | 21.12.2012  | 7:30     | L, Lenny  | Uran rangieren  | Brennstabpolierer  | Shut down             | Reactor       |
