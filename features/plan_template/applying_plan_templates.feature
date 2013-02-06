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
        | qualification      | name               | organization      |
        | Brennstabpolierer  | Brennstabpolierer  | the organization  |
        | Brennstabexperte   | Brennstabexperte   | the organization  |
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
        | Brennstabkessel(B)     | 22:00-23:59 1 x Brennstabexperte  | 00:00-06:00 1 x Brennstabexperte                        |     |     |     |     |     |
        | Druckwasserreaktor(D)  |                                   | 04:00-12:00 2 x Brennstabexperte 1 x Brennstabpolierer  |     |     |     |     |     |
      And a plan exists with organization: the organization

  Scenario: Applying a weekbased plan template to a plan in 2012, check week offset problem in 2012
    Given today is 2012-12-04
      And an employee exists with first_name: "Homer", last_name: "Simpson", account: the account
      And a membership exists with organization: the organization, employee: the employee

      And I go to the teams in week page of the plan for year: 2012, week: 49
      And I follow "Planvorlage anwenden"
      And I wait for the modal box to appear
      And I select "Typische Woche" from "Planvorlage"
      And I press "Anwenden"
      And I wait for the modal box to disappear
     Then I should be on the teams in week page of the plan for year: 2012, week: 49
      And I should see notice "Alle Schichten der Planvorlage wurden erfolgreich übernommen"
      And I should see the following calendar:
        | Teams                   | Mo                            | Di                                                                                       | Mi  | Do  | Fr  | Sa  | So  |
        | Brennstabkessel (B)     | 22:00-23:59 Brennstabexperte  | 00:00-06:00 Brennstabexperte                                                             |     |     |     |     |     |
        | Druckwasserreaktor (D)  |                               | 04:00-12:00 04:00-12:00 04:00-12:00 Brennstabexperte Brennstabexperte Brennstabpolierer  |     |     |     |     |     |

      When I click on the scheduling "22:00-23:59"
      And I select "Homer Simpson" from "Mitarbeiter"
      And I press "Speichern"
     Then I should see the following calendar:
        | Teams                   | Mo                                          | Di                                                                                       | Mi  | Do  | Fr  | Sa  | So  |
        | Brennstabkessel (B)     | Homer Simpson 22:00-00:00 Brennstabexperte  | 00:00-06:00 Brennstabexperte                                                             |     |     |     |     |     |
        | Druckwasserreaktor (D)  |                                             | 04:00-12:00 04:00-12:00 04:00-12:00 Brennstabexperte Brennstabexperte Brennstabpolierer  |     |     |     |     |     |
    # TODO: remove above calendar step and use the following instead after merge
     # Then I should see the following calendar:
     #    | Teams                   | Mo                                          | Di                                                                                       | Mi  | Do  | Fr  | Sa  | So  |
     #    | Brennstabkessel (B)     | Homer Simpson 22:00-23:59 Brennstabexperte  | Homer Simpson 00:00-06:00 Brennstabexperte                                                             |     |     |     |     |     |
     #    | Druckwasserreaktor (D)  |                                             | 04:00-12:00 04:00-12:00 04:00-12:00 Brennstabexperte Brennstabexperte Brennstabpolierer  |     |     |     |     |     |


  # TODO: remove this feature if week offset problem is fixed in niklas branch
  Scenario: Applying a weekbased plan template to a plan in 2013, check week offset problem in 2013
    Given today is 2013-02-06
      And I go to the teams in week page of the plan for year: 2013, week: 6
      And I follow "Planvorlage anwenden"
      And I wait for the modal box to appear
      And I select "Typische Woche" from "Planvorlage"
      And I press "Anwenden"
      And I wait for the modal box to disappear
     Then I should be on the teams in week page of the plan for year: 2013, week: 6
      And I should see notice "Alle Schichten der Planvorlage wurden erfolgreich übernommen"
      And I should see the following calendar:
        | Teams                   | Mo                            | Di                                                                                       | Mi  | Do  | Fr  | Sa  | So  |
        | Brennstabkessel (B)     | 22:00-23:59 Brennstabexperte  | 00:00-06:00 Brennstabexperte                                                             |     |     |     |     |     |
        | Druckwasserreaktor (D)  |                               | 04:00-12:00 04:00-12:00 04:00-12:00 Brennstabexperte Brennstabexperte Brennstabpolierer  |     |     |     |     |     |

  Scenario: Applying a weekbased plan template on the employees in week page
    Given today is 2012-12-04
      And an employee exists with first_name: "Homer", last_name: "Simpson", account: the account
      And a membership exists with organization: the organization, employee: the employee

      And I go to the employees in week page of the plan for year: 2012, week: 49
      And I follow "Planvorlage anwenden"
      And I wait for the modal box to appear
      And I select "Typische Woche" from "Planvorlage"
      And I press "Anwenden"
      And I wait for the modal box to disappear
     Then I should be on the teams in week page of the plan for year: 2012, week: 49
      And I should see notice "Alle Schichten der Planvorlage wurden erfolgreich übernommen"
      And I should see the following calendar:
        | Teams                   | Mo                            | Di                                                                                       | Mi  | Do  | Fr  | Sa  | So  |
        | Brennstabkessel (B)     | 22:00-23:59 Brennstabexperte  | 00:00-06:00 Brennstabexperte                                                             |     |     |     |     |     |
        | Druckwasserreaktor (D)  |                               | 04:00-12:00 04:00-12:00 04:00-12:00 Brennstabexperte Brennstabexperte Brennstabpolierer  |     |     |     |     |     |
