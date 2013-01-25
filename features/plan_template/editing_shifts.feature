Feature: Editing shifts of plan templates
  As I planner
  I want to edit the shifts of my plan templates
  In order to be able to change the demands which exist for a typical work week in my organization

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
        | shift               | plan_template     | start_hour | end_hour | team                      |
        | Early morning shift | the plan template | 4          | 12       | team "Druckwasserreaktor" |
      And the following demands exist:
        | shift                       | quantity | qualification                     |
        | shift "Early morning shift" | 2        | qualification "Brennstabpolierer" |
        | shift "Early morning shift" | 4        | qualification "Brennstabexperte"  |

  @javascript
  Scenario: Editing shifts of a plan template
     When I go to the teams in week page for the plan template
     Then I should see the following calendar:
        | Teams                  | Mo  | Di                                                      | Mi  | Do  | Fr  | Sa  | So  |
        | Brennstabkessel(B)     |     |                                                         |     |     |     |     |     |
        | Druckwasserreaktor(D)  |     | 04:00-12:00 2 x Brennstabpolierer 4 x Brennstabexperte  |     |     |     |     |     |

      When I click on the shift "04:00-12:00"
      And I wait for the modal box to appear
      And I select "13" from "Endstunde"
      And I select "Brennstabkessel" from "Team"
      And I fill in the 1st "Anzahl" with "1"
      And I fill in the 2nd "Anzahl" with "3"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
        | Teams                  | Mo  | Di                                                      | Mi  | Do  | Fr  | Sa  | So  |
        | Brennstabkessel(B)     |     | 04:00-13:00 1 x Brennstabpolierer 3 x Brennstabexperte  |     |     |     |     |     |
        | Druckwasserreaktor(D)  |     |                                                         |     |     |     |     |     |
