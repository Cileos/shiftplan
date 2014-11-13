@javascript
Feature: Create a plan template
  In order to avoid manually setting up a template similar to an alread yexisting week
  As a planer
  I want to create plan templates from existing weeks


  Background:
    Given today is 2012-12-03
      And the situation of a nuclear reactor

  Scenario: Create from the week view of a plan
    Given the following qualifications exist:
        | qualification | name      | account     |
        | Schwitzen     | Schwitzen | the account |
        | Nase          | Nase      | the account |
      And the following schedulings exist:
        | plan     | date       | employee         | quickie          | qualification             |
        | the plan | 2012-12-04 | employee "Homer" | 10-16 Inspektion | qualification "Schwitzen" |
        | the plan | 2012-12-05 | employee "Homer" | 22-23            | qualification "Schwitzen" |
        | the plan | 2012-12-06 | employee "Homer" | 12-14 Schlafen   |                           |
        | the plan | 2012-12-10 | employee "Homer" | 10-18 Urlaub     |                           |
        | the plan | 2012-12-03 | employee "Lenny" | 9-17 Popeln      | qualification "Nase"      |
        | the plan | 2012-12-04 | employee "Lenny" | 10-16 Inspektion | qualification "Schwitzen" |
        | the plan | 2012-12-03 | employee "Carl"  | 9-17 Popeln      | qualification "Nase"      |
        | the plan | 2012-12-04 | employee "Carl"  | 10-17 Inspektion | qualification "Schwitzen" |
      # Carl has to stay one hour longer => single shift
      # on 5th, there is no team assigned so we ignore it
      And I am on the page of the plan
      And I should see the following partial calendar:
       | Mitarbeiter      | Mo                 | Di                      | Mi                    | Do            | Fr |
       | Planner Burns    |                    |                         |                       |               |    |
       | Carl C           | 09:00-17:00 P Nase | 10:00-17:00 I Schwitzen |                       |               |    |
       | Lenny L          | 09:00-17:00 P Nase | 10:00-16:00 I Schwitzen |                       |               |    |
       | Homer S          |                    | 10:00-16:00 I Schwitzen | 22:00-23:00 Schwitzen | 12:00-14:00 S |    |
       | Ohne Mitarbeiter |                    |                         |                       |               |    |


     When I choose "Neue Planvorlage" from the drop down "Weitere Aktionen"
      And I wait for the modal box to appear
     Then the "Name" field should contain "KW 49"
     When I fill in "Name" with "Inspektionswoche"
      And I check "6 Einträge in Vorlage einbeziehen"
      And I press "Anlegen"
     Then a plan template should exist
      And I should be on the teams in week page for the plan template
     Then I should see the following partial calendar:
       | Teams         | Mo                   | Di                                                  | Mi | Do              | Fr |
       | Inspektion(I) |                      | 10:00-17:00 10:00-16:00 1 x Schwitzen 2 x Schwitzen |    |                 |    |
       | Popeln(P)     | 09:00-17:00 2 x Nase |                                                     |    |                 |    |
       | Schlafen(S)   |                      |                                                     |    | 12:00-14:00 1 x |    |
       | Urlaub(U)     |                      |                                                     |    |                 |    |
       # sorry, your vacation is in another week

     When I go to the page of the plan
      And I choose "Neue Planvorlage" from the drop down "Weitere Aktionen"
      And I wait for the modal box to appear
      And I fill in "Name" with "Inspektionswoche"
      And I press "Anlegen"
     Then I should see the following validation errors:
       | Name | ist bereits vergeben |
