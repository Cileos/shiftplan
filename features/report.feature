Feature: Report
  In order to keep an overview of the schedulings
  As an owner
  I want to see a list of all the schedulings of my account or of an organization of my account

  Background:
    Given mr burns, owner of the Springfield Nuclear Power Plant exists
     When I am signed in as the user "mr burns"

  Scenario: Report for account with two organizations
    # More springfield account data:
    Given a team exists with name: "Uran rangieren", organization: organization "sector 7g"
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

      # Foreign account data:
      And an account "tv business" exists with name: "TV Business"
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
      And I should see the following table of reports:
        | Datum       | Stunden  | Name            | Team            | Qualifikation      | Plan               | Organisation  |
        | 23.12.2012  | 7,50     | Burns, Charles  |                 |                    | Shut down          | Sector 7-G    |
        | 21.12.2012  | 8,50     | Burns, Charles  | Uran rangieren  | Brennstabpolierer  | Shut down          | Sector 7-G    |
        | 19.12.2012  | 6,75     | Simpson, Homer  |                 |                    | Lie to the public  | PR            |
      And I should see "22,75" within the header aggregation within the reports table
