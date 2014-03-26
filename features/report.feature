Feature: Report
  In order to keep an overview of the schedulings
  As an owner or planner
  I want to see a list of all the schedulings of my account or of an organization of my account

  Background:
    Given today is 2012-12-04
      And mr burns, owner of the Springfield Nuclear Power Plant exists
      # More springfield account data:
      And a team exists with name: "Uran rangieren", organization: organization "sector 7g"
      And a qualification exists with name: "Brennstabpolierer", account: the account
      And an organization "pr" exists with name: "PR", account: the account
      And an employee "homer" exists with first_name: "Homer", account: the account
      And the employee "homer" is a member of the organization "pr"
      And the following plans exist:
        | plan               | name               | organization              |
        | lie to the public  | Lie to the public  | organization "pr"         |
        | shut down          | Shut down          | organization "sector 7g"  |
      And the following schedulings exists:
        | date        | employee                   | quickie  | plan                      | team      | qualification      |
        | 23.12.2012  | employee owner "mr burns"  | 7-14:30  | plan "shut down"          |           |                    |
        | 21.12.2012  | employee owner "mr burns"  | 7-15:30  | plan "shut down"          | the team  | the qualification  |
        | 19.12.2012  | employee "homer"           | 7-13:45  | plan "lie to the public"  |           |                    |
        | 17.11.2012  | employee owner "mr burns"  | 7-14:30  | plan "shut down"          |           |                    |
     When I am signed in as the user "mr burns"

  Scenario: Owner visits current month report for account
      # Foreign account data:
    Given an account "tv business" exists with name: "TV Business"
      And a organization "the clown show" exists with account: account "tv business", name: "The Clown Show"
      And a plan "make fun of homer" exists with organization: organization "the clown show", name: "Make fun of homer"
      And an employee "krusty" exists with first_name: "Krusty", last_name: "Krustofski"
      And the employee "krusty" is a member of the organization "the clown show"
      # Krusty's scheduling should not show up in the report of the springfield
      # account as it belongs to the foreign tv business account.
      And the following schedulings exists:
        | date        | employee                   | quickie  | plan                      |
        | 18.12.2012  | employee "krusty"          | 9-9:30   | plan "make fun of homer"  |

     When I go to the dashboard page
      And I follow "Report"
      # schedulings of both organizations of the springfield account are listed
     Then I should see the following table of reports:
        | Datum       | Stunden  | Mitarbeiter     | Team            | Qualifikation      | Plan               | Organisation  |
        | 23.12.2012  | 7,50     | Burns, Charles  |                 |                    | Shut down          | Sector 7-G    |
        | 21.12.2012  | 8,50     | Burns, Charles  | Uran rangieren  | Brennstabpolierer  | Shut down          | Sector 7-G    |
        | 19.12.2012  | 6,75     | Simpson, Homer  |                 |                    | Lie to the public  | PR            |
      And I should see "22,75" within the header aggregation within the reports table


  Scenario: Owner visits current month report for organization
     When I go to the page of the organization "sector 7g"
      And I choose "Report" from the drop down "Info"
      # only schedulings of organization sector 7g should be shown
     Then I should see the following table of reports:
        | Datum       | Stunden  | Mitarbeiter     | Team            | Qualifikation      | Plan               | Organisation  |
        | 23.12.2012  | 7,50     | Burns, Charles  |                 |                    | Shut down          | Sector 7-G    |
        | 21.12.2012  | 8,50     | Burns, Charles  | Uran rangieren  | Brennstabpolierer  | Shut down          | Sector 7-G    |
      And I should see "16,00" within the header aggregation within the reports table


  Scenario: Planner visits current month report for organization
    Given a confirmed user "bart" exists
      And an employee "bart" exists with first_name: "Bart", account: the account, user: user "bart"
      And the employee "bart" is a planner of the organization "sector 7g"
      And I am signed in as the user "bart"
     When I go to the page of the organization "sector 7g"
      And I choose "Report" from the drop down "Info"
      # only schedulings of organization sector 7g should be shown
     Then I should see the following table of reports:
        | Datum       | Stunden  | Mitarbeiter     | Team            | Qualifikation      | Plan               | Organisation  |
        | 23.12.2012  | 7,50     | Burns, Charles  |                 |                    | Shut down          | Sector 7-G    |
        | 21.12.2012  | 8,50     | Burns, Charles  | Uran rangieren  | Brennstabpolierer  | Shut down          | Sector 7-G    |
      And I should see "16,00" within the header aggregation within the reports table


  Scenario: Owner filters by organization
     When I go to the report page of the account
      And I select "Sector 7-G" from "Organisation"
      And I press "Filtern"
     Then I should see the following table of reports:
        | Datum       | Stunden  | Mitarbeiter     | Team            | Qualifikation      | Plan               | Organisation  |
        | 23.12.2012  | 7,50     | Burns, Charles  |                 |                    | Shut down          | Sector 7-G    |
        | 21.12.2012  | 8,50     | Burns, Charles  | Uran rangieren  | Brennstabpolierer  | Shut down          | Sector 7-G    |
      And I should see "16,00" within the header aggregation within the reports table
      And the selected "Organisation" should be "Sector 7-G"

  @javascript
  Scenario: Owner filters by date
     When I go to the report page of the account
      And the following schedulings exists:
        | date        | employee          | quickie  | plan              |
        | 17.11.2012  | employee "Homer"  | 0-24:00  | plan "Shut down"  |
     # default to current month
     Then the "Von" field should contain "01.12.2012"
      And the "Bis" field should contain "31.12.2012"

     When I pick "17. November 2012" from "Von"
      And I pick "21. Dezember 2012" from "Bis"
      And I press "Filtern"
     Then I should see the following table of reports:
        | Datum       | Stunden  | Mitarbeiter     | Team            | Qualifikation      | Plan               | Organisation  |
        | 21.12.2012  | 8,50     | Burns, Charles  | Uran rangieren  | Brennstabpolierer  | Shut down          | Sector 7-G    |
        | 19.12.2012  | 6,75     | Simpson, Homer  |                 |                    | Lie to the public  | PR            |
        | 17.11.2012  | 7,50     | Burns, Charles  |                 |                    | Shut down          | Sector 7-G    |
        | 17.11.2012  | 24,00    | Simpson, Homer  |                 |                    | Shut down          | Sector 7-G    |
      And I should see "46,75" within the header aggregation within the reports table

  Scenario: Owner filters by employee
     When I go to the report page of the account
      And I select "Homer Simpson" from "Mitarbeiter"
      And I press "Filtern"
     Then I should see the following table of reports:
        | Datum       | Stunden  | Name            | Plan               | Organisation  |
        | 19.12.2012  | 6,75     | Simpson, Homer  | Lie to the public  | PR            |
      And the selected "Mitarbeiter" should be "Homer Simpson"
