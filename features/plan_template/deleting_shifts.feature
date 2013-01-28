@javascript
Feature: Deleting shifts of plan templates
  As a planner
  I want to delete shifts from my plan templates
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
     When I go to the teams in week page for the plan template
     Then I should see the following calendar:
        | Teams                  | Mo  | Di                                                      | Mi  | Do  | Fr  | Sa  | So  |
        | Brennstabkessel(B)     |     |                                                         |     |     |     |     |     |
        | Druckwasserreaktor(D)  |     | 04:00-12:00 2 x Brennstabpolierer 4 x Brennstabexperte  |     |     |     |     |     |


  Scenario: Deleting shifts of a plan template
    Given I click on the shift "04:00-12:00"
      And I wait for the modal box to appear
      And I follow "Löschen"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
        | Teams                  | Mo  | Di  | Mi  | Do  | Fr  | Sa  | So  |
        | Brennstabkessel(B)     |     |     |     |     |     |     |     |
        | Druckwasserreaktor(D)  |     |     |     |     |     |     |     |
