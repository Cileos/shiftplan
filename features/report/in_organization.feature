Feature: Report
  In order to keep an overview of the schedulings
  As an owner or planner
  I want to see a list of all the schedulings of my account or of an organization of my account

  Background:
    Given today is 2012-12-04
      And mr burns, owner of the Springfield Nuclear Power Plant exists
      And I am signed in as the user "mr burns"
      And a account "bowling" exists with name: "Springfield Bowling Club"
      And an organization "male bowling" exists with name: "Herren Bowling", account: account "bowling"
      And an employee "charly burns" exists with first_name: "Charly", last_name: "Burns", account: account "bowling", user: the user
      And the employee "charly burns" is a planner of the organization "male bowling"
      And an employee "homer simpson" exists with first_name: "Homer", last_name: "Simpson", account: account "bowling"
      And a plan "bundesliga" exists with organization: organization "male bowling", name: "Bundesliga"
      And the following schedulings exists:
        | date        | employee                  | quickie | plan              |
        | 04.12.2012  | employee "charly burns"   | 20-22   | plan "bundesliga" |
        | 20.12.2012  | employee "charly burns"   | 20-22   | plan "bundesliga" |
        | 21.12.2012  | employee "homer simpson"  | 10-12   | plan "bundesliga" |
     When I go to the page of the organization "male bowling"
      And I choose "Report" from the drop down "Info"
     Then I should see the following table of reports:
        | Datum       | Stunden  | Mitarbeiter     | Plan        | Organisation    |
        | 21.12.2012  | 2,00     | Simpson, Homer  | Bundesliga  | Herren Bowling  |
        | 20.12.2012  | 2,00     | Burns, Charly   | Bundesliga  | Herren Bowling  |
        | 04.12.2012  | 2,00     | Burns, Charly   | Bundesliga  | Herren Bowling  |


  Scenario: Planner visits organization report page and downloads csv
     When I follow "Als CSV-Datei exportieren"
     Then I should see the following semicolon separated csv file:
      | Mitarbeiter    | Datum       | Stunden  | Plan        | Organisation    |
      | Simpson, Homer | 21.12.2012  | 2,00     | Bundesliga  | Herren Bowling  |
      | Burns, Charly  | 20.12.2012  | 2,00     | Bundesliga  | Herren Bowling  |
      | Burns, Charly  | 04.12.2012  | 2,00     | Bundesliga  | Herren Bowling  |

     When I go to the report page of the organization "male bowling"
     When I select "Charly Burns" from "Mitarbeiter"
      And I press "Filtern"
     Then I should see the following table of reports:
        | Datum       | Stunden  | Mitarbeiter    | Plan       | Organisation    |
        | 20.12.2012  | 2,00     | Burns, Charly  | Bundesliga | Herren Bowling  |
        | 04.12.2012  | 2,00     | Burns, Charly  | Bundesliga | Herren Bowling  |
     When I follow "Als CSV-Datei exportieren"
     Then I should see the following semicolon separated csv file:
      | Mitarbeiter    | Datum       | Stunden  | Plan        | Organisation    |
      | Burns, Charly  | 20.12.2012  | 2,00     | Bundesliga  | Herren Bowling  |
      | Burns, Charly  | 04.12.2012  | 2,00     | Bundesliga  | Herren Bowling  |


  Scenario: Planner filters by time range
     When I select "Heute" from "Zeitraum"
      And I press "Filtern"
