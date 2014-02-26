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
    And a qualification "Brennstabpolierer" exists with account: the account, name: "Brennstabpolierer"
    And a scheduling exists with employee: employee "Lenny", plan: the plan "lie to the public", date: "2012-12-21", quickie: "7-14:30"

    # Then the employee "Lenny" was scheduled in the plan "lie to the public" as following:
    #     | date       | quickie |
    #     | 2012-12-21 | 7-14:30 |
    And a scheduling exists with employee: employee "Lenny", plan: the plan "shut down", date: "2012-12-21", quickie: "7-14:30", team: the team "Uran rangieren", qualification: the qualification "Brennstabpolierer"
    # Then the employee "Lenny" was scheduled in the plan "shut down" as following:
    #     | date       | quickie                  |
    #     | 2012-12-21 | 7-14:30  Uran rangieren  |
    And the employee "Homer" was scheduled in the plan "shut down" as following:
        | date       | quickie |
        | 2012-12-21 | 8-16:30 |
    And the employee "Lenny" was scheduled in the plan "clean reactor" as following:
        | date       | quickie |
        | 2013-01-15 | 7-14:30 |
    And I choose "Reactor" from the drop down "Organisation"
    And I choose "Report" from the drop down "Info"
    And I should see the following table of reports:
      | Datum       | Stunden  | Name      | Team            | Qualifikation      | Plan                  | Organisation  |
      | 15.01.2013  | 7:30     | L, Lenny  |                 |                    | Cleaning the Reactor  | Reactor       |
      | 21.12.2012  | 8:30     | S, Homer  |                 |                    | Shut down             | Reactor       |
      | 21.12.2012  | 7:30     | L, Lenny  | Uran rangieren  | Brennstabpolierer  | Shut down             | Reactor       |
