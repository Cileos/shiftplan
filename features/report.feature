Feature: Report
  In order to keep an overview of the schedulings
  As an employee
  I want to see a list of all the schedulings of the organization

  Background:
    Given the situation of a nuclear reactor
      And the employee "Burns" is the owner of the account

  Scenario:
    Given a organization "PR" exist with account: the account, name: "PR"
    And a plan "lie to the public" exists with organization: organization "PR", name: "Lie to the public"
    And a plan "shut down" exists with organization: organization "Reactor", name: "Shut down"
    And a team "Uran rangieren" exists with organization: organization: "Reactor", name: "Uran rangieren"
    And a qualification exists with account: the account, name: "Brennstabpolierer"
    # Krusty will never show up in the reactor, so he shouldn't be in the report of the tepco account
    And an account "TV Business" exist with name: "TV Business"
    And a organization "The Clown Show" exist with account: account "TV Business", name: "The Clown Show"
    And a plan "make fun of homer" exists with organization: organization "The Clown Show", name: "Make fun of homer"
    And a confirmed user "Krusty" exists with email: "krusty@clockwork.local"
    And the following employees exist:
      | account                    | employee  | first_name  | last_name  | user                     | weekly_working_time  |
      | the account "TV Business"  | Krusty    | Planner     | Krusty     | confirmed user "Krusty"  |                      |

    And the following schedulings exists:
      | date        | employee          | quickie  | plan                          | team                       | qualification      |
      | 2012-12-23  | employee "Lenny"  | 7-14:30  | the plan "lie to the public"  |                            |                    |
      | 2012-12-21  | employee "Lenny"  | 7-14:30  | the plan "shut down"          | the team "Uran rangieren"  | the qualification  |
      | 2012-12-21  | employee "Homer"  | 8-16:30  | the plan "shut down"          |                            |                    |
      | 2013-01-15  | employee "Lenny"  | 7-14:30  | the plan "clean reactor"      |                            |                    |
      | 2013-01-20  | employee "Homer"  | 22-4:45  | the plan "clean reactor"      |                            |                    |
      | 2013-01-06  | employee "Krusty" | 9-9:30   | the plan "make fun of homer"  |                            |                    |

    And I choose "Reactor" from the drop down "Organisation"
    And I choose "Report" from the drop down "Info"
    And I should see the following table of reports:
      | Datum      | Stunden | Name     | Team           | Qualifikation     | Plan                 | Organisation |
      | 20.01.2013 | 6.75    | S, Homer |                |                   | Cleaning the Reactor | Reactor      |
      | 15.01.2013 | 7.5     | L, Lenny |                |                   | Cleaning the Reactor | Reactor      |
      | 23.12.2012 | 7.5     | L, Lenny |                |                   | Lie to the public    | PR           |
      | 21.12.2012 | 8.5     | S, Homer |                |                   | Shut down            | Reactor      |
      | 21.12.2012 | 7.5     | L, Lenny | Uran rangieren | Brennstabpolierer | Shut down            | Reactor      |
    And I should see "37.75" within the header aggregation within the reports table
