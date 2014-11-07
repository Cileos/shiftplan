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
      And a qualification "superstriker" exists with name: "Superstriker", account: account "bowling"
      And a team "loser" exists with name: "Loser", organization: organization "male bowling"
      And an employee "charly burns" exists with first_name: "Chârly", last_name: "Burns", account: account "bowling", user: the user
      And the employee "charly burns" is a planner of the organization "male bowling"
      And an employee "homer simpson" exists with first_name: "Hômèr", last_name: "Simpson", account: account "bowling"
      And a plan "bundesliga" exists with organization: organization "male bowling", name: "Bundesliga"
      And the following schedulings exists:
        | date       | employee                 | quickie | plan              | team         | qualification                | all_day | actual_length_in_hours |
        | 04.12.2012 | employee "charly burns"  | 20-22   | plan "bundesliga" | team "loser" | qualification "superstriker" | false   |                        |
        | 04.12.2012 | employee "charly burns"  |         | plan "bundesliga" | team "loser" | qualification "superstriker" | true    |                        |
        | 05.12.2012 | employee "charly burns"  |         | plan "bundesliga" | team "loser" | qualification "superstriker" | true    | 7.5                    |
        | 20.12.2012 | employee "charly burns"  | 20-22   | plan "bundesliga" |              |                              | false   |                        |
        | 21.12.2012 | employee "homer simpson" | 10-12   | plan "bundesliga" |              |                              | false   | 20                     |
     #                                                                                                                                  ^^ ignored for non all-day


  Scenario: Planner visits organization report page and downloads csv
     When I go to the page of the organization "male bowling"
      And I choose "Report" from the drop down "Info"
     Then I should see the following table of reports:
        | Datum       | Stunden  | Mitarbeiter     | Plan        | Organisation    | Team   | Qualifikation  |
        | 21.12.2012  | 2,00     | Simpson, Hômèr  | Bundesliga  | Herren Bowling  |        |                |
        | 20.12.2012  | 2,00     | Burns, Chârly   | Bundesliga  | Herren Bowling  |        |                |
        | 05.12.2012  | 7,50     | Burns, Chârly   | Bundesliga  | Herren Bowling  | Loser  | Superstriker   |
        | 04.12.2012  | 2,00     | Burns, Chârly   | Bundesliga  | Herren Bowling  | Loser  | Superstriker   |
        | 04.12.2012  | 0,00     | Burns, Chârly   | Bundesliga  | Herren Bowling  | Loser  | Superstriker   |

     When I go to the report page of the organization "male bowling"
      And I select "Chârly Burns" from "Mitarbeiter"
      And I press "Filtern"
     Then I should see the following table of reports:
        | Datum       | Stunden  | Mitarbeiter    | Plan       | Organisation    |
        | 20.12.2012  | 2,00     | Burns, Chârly  | Bundesliga | Herren Bowling  |
        | 05.12.2012  | 7,50     | Burns, Chârly  | Bundesliga | Herren Bowling  |
        | 04.12.2012  | 2,00     | Burns, Chârly  | Bundesliga | Herren Bowling  |
        | 04.12.2012  | 0,00     | Burns, Chârly  | Bundesliga | Herren Bowling  |
     When I follow "Als CSV-Datei exportieren"
     Then I should see the following semicolon separated csv file:
      | Mitarbeiter    | Datum       | Stunden | Ganztägig | Plan        | Organisation    | Team   | Qualifikation  |
      | Burns, Chârly  | 20.12.2012  | 2,00    | nein      | Bundesliga  | Herren Bowling  |        |                |
      | Burns, Chârly  | 05.12.2012  | 7,50    | ja        | Bundesliga  | Herren Bowling  | Loser  | Superstriker   |
      | Burns, Chârly  | 04.12.2012  | 2,00    | nein      | Bundesliga  | Herren Bowling  | Loser  | Superstriker   |
      | Burns, Chârly  | 04.12.2012  | 0,00    | ja        | Bundesliga  | Herren Bowling  | Loser  | Superstriker   |

     When I go to the report page of the organization "male bowling"
     When I follow "Als Excel-Datei exportieren"
