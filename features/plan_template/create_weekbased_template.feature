Feature: Create Weekbased Plan Template
  As I planner
  I want to create a weekbased plan template
  In order to be able to define demands which I exist for a typical work week in my organization

  Scenario: Create weekbased plan template
    Given the situation of a just registered user
      And the following qualifications exist:
        | name               | organization      |
        | Brennstabpolierer  | the organization  |
        | Brennstabexperte   | the organization  |
      And the following teams exist:
        | name               | organization      |
        | Brennstabkessel    | the organization  |
        | Druckwasserreaktor | the organization  |
      And a plan exists with name: "Brennstabpflege", organization: the organization

     When I go to the page of the plan
      And I follow "Neue Planvorlage"
     Then I should be on the new plan template page for the organization

     When I fill in "Name" with "Typische Woche in der Brennstabpflege"
      And I select "Wochenbasiert" from "Vorlagentyp"
      And I press "Anlegen"
     Then a plan template should exist with organization: the organization
      And I should be on the teams in week page for the plan template
      And I should see the following calendar:
        | Teams                 | Mo  | Di  | Mi  | Do  | Fr  | Sa  | So  |
        | Brennstabkessel(B)    |     |     |     |     |     |     |     |
        | Druckwasserreaktor(D) |     |     |     |     |     |     |     |
