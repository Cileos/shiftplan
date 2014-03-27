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
        | 20.12.2012  | employee "homer"           | 7-16:00  | plan "shut down"          | the team  | the qualification  |
        | 19.12.2012  | employee "homer"           | 7-13:45  | plan "lie to the public"  |           |                    |
        | 17.11.2012  | employee owner "mr burns"  | 7-14:30  | plan "shut down"          |           |                    |
        | 17.11.2012  | employee "homer"           | 0-24:00  | plan "Shut down"          |           |                    |
     When I am signed in as the user "mr burns"

  # most common path scenario
  @javascript
  Scenario: Owner uses filters on account report page
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
      # Schedulings of both organizations of the springfield account are listed.
      # Per default only the schedulings of the current month are listed.
     Then I should see the following table of reports:
        | Datum       | Stunden  | Mitarbeiter     | Team            | Qualifikation      | Plan               | Organisation  |
        | 23.12.2012  | 7,50     | Burns, Charles  |                 |                    | Shut down          | Sector 7-G    |
        | 21.12.2012  | 8,50     | Burns, Charles  | Uran rangieren  | Brennstabpolierer  | Shut down          | Sector 7-G    |
        | 20.12.2012  | 9,00     | Simpson, Homer  | Uran rangieren  | Brennstabpolierer  | Shut down          | Sector 7-G    |
        | 19.12.2012  | 6,75     | Simpson, Homer  |                 |                    | Lie to the public  | PR            |
      And I should see "31,75" within the header aggregation within the reports table

      And the "Von" field should contain "01.12.2012"
      And the "Bis" field should contain "31.12.2012"

     When I select "Sector 7-G" from the "Organisation" multiple-select box
      And I select "Homer Simpson" from the "Mitarbeiter" multiple-select box
      And I pick "17. November 2012" from "Von"
      And I pick "21. Dezember 2012" from "Bis"
      And I press "Filtern"
     Then I should see the following table of reports:
        | Datum       | Stunden  | Mitarbeiter     | Team            | Qualifikation      | Plan       | Organisation  |
        | 20.12.2012  | 9,00     | Simpson, Homer  | Uran rangieren  | Brennstabpolierer  | Shut down  | Sector 7-G    |
        | 17.11.2012  | 24,00    | Simpson, Homer  |                 |                    | Shut down  | Sector 7-G    |
      And I should see "33,00" within the header aggregation within the reports table

  Scenario: Owner visits organization report page
     When I go to the page of the organization "sector 7g"
      And I choose "Report" from the drop down "Info"
      # only schedulings of organization sector 7g should be shown
     Then I should see the following table of reports:
        | Datum       | Stunden  | Mitarbeiter     | Team            | Qualifikation      | Plan               | Organisation  |
        | 23.12.2012  | 7,50     | Burns, Charles  |                 |                    | Shut down          | Sector 7-G    |
        | 21.12.2012  | 8,50     | Burns, Charles  | Uran rangieren  | Brennstabpolierer  | Shut down          | Sector 7-G    |
        | 20.12.2012  | 9,00     | Simpson, Homer  | Uran rangieren  | Brennstabpolierer  | Shut down          | Sector 7-G    |
      And I should see "25,00" within the header aggregation within the reports table
