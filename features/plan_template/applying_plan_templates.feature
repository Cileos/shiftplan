Feature: Applying Weekbased Plan Templates to Plans
  As I planner
  I want to apply a weekbased plan template to my plan
  In order to create schedulings for demands which exist for a typical work week in my organization

  Background:
    Given today is 2012-12-04
      And the situation of a just registered user
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
        | Brennstabkessel     | the plan template  | 0   | 8           | 17        | team "Brennstabkessel"     |
      And the following demands exist:
        | demand                      | quantity  | qualification                      |
        | Brennstabpolierer           | 1         | qualification "Brennstabpolierer"  |
        | Brennstabexperte            | 2         | qualification "Brennstabexperte"   |
        | Einfacher Brennstabexperte  | 1         | qualification "Brennstabexperte"  |
      And the following demands shifts exist:
        | shift                           | demand                                   |
        | the shift "Druckwasserreaktor"  | the demand "Brennstabpolierer"           |
        | the shift "Druckwasserreaktor"  | the demand "Brennstabexperte"            |
        | the shift "Brennstabkessel"     | the demand "Einfacher Brennstabexperte"  |
     When I go to the teams in week page for the plan template
     Then I should see the following calendar:
        | Teams                  | Mo                                | Di                                                      | Mi  | Do  | Fr  | Sa  | So  |
        | Brennstabkessel(B)     | 08:00-17:00 1 x Brennstabexperte  |                                                         |     |     |     |     |     |
        | Druckwasserreaktor(D)  |                                   | 04:00-12:00 2 x Brennstabexperte 1 x Brennstabpolierer  |     |     |     |     |     |
      And a plan exists with organization: the organization

  @javascript
  Scenario: Applying a weekbased plan template to a plan
    Given I go to the teams in week page of the plan for year: 2012, week: 49
      And I follow "Planvorlage anwenden"
      And I wait for the modal box to appear
      And I select "Typische Woche" from "Planvorlage"
      And I press "Anwenden"
      And I wait for the modal box to disappear
     Then I should be on the teams in week page of the plan for year: 2012, week: 49
      And I should see notice "Alle Schichten der Planvorlage wurden erfolgreich übernommen"
      # TODO
      # And I should see the following calendar:
      #   | Teams                  | Mo                            | Di                                                                                       | Mi  | Do  | Fr  | Sa  | So  |
      #   | Brennstabkessel(B)     | 08:00-17:00 Brennstabexperte  |                                                                                          |     |     |     |     |     |
      #   | Druckwasserreaktor(D)  |                               | 04:00-12:00 Brennstabexperte 04:00-12:00 Brennstabexperte 04:00-12:00 Brennstabpolierer  |     |     |     |     |     |
