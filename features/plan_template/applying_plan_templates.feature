@javascript
Feature: Applying Weekbased Plan Templates to Plans
  As I planner
  I want to apply a weekbased plan template to my plan
  In order to create schedulings for demands which exist for a typical work week in my organization

  Background:
    Given the situation of a just registered user
      And a plan template exists with name: "Typische Woche", template_type: "weekbased", organization: the organization
      And the following teams exist:
        | team                | name                | organization      |
        | Brennstabkessel     | Brennstabkessel     | the organization  |
        | Druckwasserreaktor  | Druckwasserreaktor  | the organization  |
      And the following qualifications exist:
        | qualification      | name               | account      |
        | Brennstabpolierer  | Brennstabpolierer  | the account  |
        | Brennstabexperte   | Brennstabexperte   | the account  |
      And the following shifts exists:
        | shift               | plan_template      | day | start_hour  | end_hour  | team                       |
        | Druckwasserreaktor  | the plan template  | 1   | 4           | 12        | team "Druckwasserreaktor"  |
        | Brennstabkessel     | the plan template  | 0   | 22          | 6         | team "Brennstabkessel"     |
      And the following demands exist:
        | shift                       | quantity  | qualification                      |
        | shift "Druckwasserreaktor"  | 1         | qualification "Brennstabpolierer"  |
        | shift "Druckwasserreaktor"  | 2         | qualification "Brennstabexperte"   |
        | shift "Brennstabkessel"     | 1         | qualification "Brennstabexperte"   |
     When I go to the teams in week page for the plan template
     Then I should see the following calendar:
        | Teams                  | Mo                                | Di                                                      | Mi  | Do  | Fr  | Sa  | So  |
        | Brennstabkessel(B)     | 22:00-24:00 1 x Brennstabexperte  | 00:00-06:00 1 x Brennstabexperte                        |     |     |     |     |     |
        | Druckwasserreaktor(D)  |                                   | 04:00-12:00 2 x Brennstabexperte 1 x Brennstabpolierer  |     |     |     |     |     |
      And a plan exists with organization: the organization

  Scenario: Applying a weekbased plan template to a plan in 2012, check week offset problem in 2012
    Given today is 2012-12-04
      And an employee exists with first_name: "Homer", last_name: "Simpson", account: the account
      And a membership exists with organization: the organization, employee: the employee

      And I go to the teams in week page of the plan for cwyear: 2012, week: 49
      And I choose "Planvorlage anwenden" from the drop down "Weitere Aktionen"
      And I wait for the modal box to appear
      And I select "Typische Woche" from "Planvorlage"
      And I press "Anwenden"
      And I wait for the modal box to disappear
     Then I should be on the teams in week page of the plan for cwyear: 2012, week: 49
      And I should see notice "Alle Schichten der Planvorlage wurden erfolgreich übernommen"
      And I should see the following calendar:
        | Teams                   | Mo                            | Di                                                                                       | Mi  | Do  | Fr  | Sa  | So  |
        | Brennstabkessel (B)     | 22:00-24:00 Brennstabexperte  | 00:00-06:00 Brennstabexperte                                                             |     |     |     |     |     |
        | Druckwasserreaktor (D)  |                               | 04:00-12:00 04:00-12:00 04:00-12:00 Brennstabexperte Brennstabexperte Brennstabpolierer  |     |     |     |     |     |

      When I click on the scheduling "22:00-24:00"
      And I select "Homer Simpson" from "Mitarbeiter"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
        | Teams                  | Mo                                         | Di                                                                                      | Mi | Do | Fr | Sa | So |
        | Brennstabkessel (B)    | Homer Simpson 22:00-24:00 Brennstabexperte | Homer Simpson 00:00-06:00 Brennstabexperte                                              |    |    |    |    |    |
        | Druckwasserreaktor (D) |                                            | 04:00-12:00 04:00-12:00 04:00-12:00 Brennstabexperte Brennstabexperte Brennstabpolierer |    |    |    |    |    |


  Scenario: Applying a weekbased plan template to a plan in 2013, check week offset problem in 2013
    Given today is 2013-02-06
      And I go to the teams in week page of the plan for cwyear: 2013, week: 6
      And I choose "Planvorlage anwenden" from the drop down "Weitere Aktionen"
      And I wait for the modal box to appear
      And I select "Typische Woche" from "Planvorlage"
      And I press "Anwenden"
      And I wait for the modal box to disappear
     Then I should be on the teams in week page of the plan for cwyear: 2013, week: 6
      And I should see notice "Alle Schichten der Planvorlage wurden erfolgreich übernommen"
      And I should see the following calendar:
        | Teams                   | Mo                            | Di                                                                                       | Mi  | Do  | Fr  | Sa  | So  |
        | Brennstabkessel (B)     | 22:00-24:00 Brennstabexperte  | 00:00-06:00 Brennstabexperte                                                             |     |     |     |     |     |
        | Druckwasserreaktor (D)  |                               | 04:00-12:00 04:00-12:00 04:00-12:00 Brennstabexperte Brennstabexperte Brennstabpolierer  |     |     |     |     |     |
    When I follow ">"
    Then I should be on the teams in week page of the plan for cwyear: 2013, week: 7
     And I choose "Übernahme aus der letzten Woche" from the drop down "Weitere Aktionen"
     And I select "KW 06 04.02.2013" from "Von"
     And I press "Übernehmen"
    Then I should be on the teams in week page of the plan for cwyear: 2013, week: 7
     And I should see the following calendar:
        | Teams                   | Mo                            | Di                                                                                       | Mi  | Do  | Fr  | Sa  | So  |
        | Brennstabkessel (B)     | 22:00-24:00 Brennstabexperte  | 00:00-06:00 Brennstabexperte                                                             |     |     |     |     |     |
        | Druckwasserreaktor (D)  |                               | 04:00-12:00 04:00-12:00 04:00-12:00 Brennstabexperte Brennstabexperte Brennstabpolierer  |     |     |     |     |     |


  Scenario: Applying a weekbased plan template to a plan with a plan period
    Given today is 2013-02-19
      # plan starts on tuesday and ends on wednesday, week 49
      And a plan exists with starts_at: "2012-12-04", ends_at: "2012-12-05", organization: the organization

      And I go to the teams in week page of the plan for cwyear: 2012, week: 49
      And I choose "Planvorlage anwenden" from the drop down "Weitere Aktionen"
      And I wait for the modal box to appear
      And I select "Typische Woche" from "Planvorlage"
      And I press "Anwenden"
      And I wait for the modal box to disappear
     Then I should be on the teams in week page of the plan for cwyear: 2012, week: 49
      And I should see notice "Es konnten nicht alle Schichten der Planvorlage übernommen werden. Einige Schichten liegen außerhalb des Plans."
      And I should see the following calendar:
        | Teams                   | Mo  | Di                                                                                       | Mi  | Do  | Fr  | Sa  | So  |
        | Brennstabkessel (B)     |     |                                                                                          |     |     |     |     |     |
        | Druckwasserreaktor (D)  |     | 04:00-12:00 04:00-12:00 04:00-12:00 Brennstabexperte Brennstabexperte Brennstabpolierer  |     |     |     |     |     |
