@javascript
Feature: Create Weekbased Plan Template
  As I planner
  I want to create a weekbased plan template
  In order to be able to define demands which exist for a typical work week in my organization

  Background:
    Given the situation of a just registered user

  Scenario: Create weekbased plan template
    Given a plan exists with name: "Brennstabpflege", organization: the organization
      And the following teams exist:
        | team                | name                | organization      |
        | Brennstabkessel     | Brennstabkessel     | the organization  |
        | Druckwasserreaktor  | Druckwasserreaktor  | the organization  |

     When I go to the plan templates page for the organization
      And I inject style "position:relative" into "header"
      And I follow "Hinzufügen"
      And I wait for the modal box to appear
     When I fill in "Name" with "Typische Woche in der Brennstabpflege"
      And I select "Wochenbasiert" from "Vorlagentyp"
      And I press "Anlegen"
      And I wait for the modal box to disappear

     Then a plan template should exist with organization: the organization
      And I should be on the plan templates page for the organization
      And I should see the following table of plan_templates:
        | Name                                   | Vorlagentyp    |
        | Typische Woche in der Brennstabpflege  | Wochenbasiert  |
     When I follow "Typische Woche in der Brennstabpflege"
     Then I should be on the teams in week page for the plan template
      And I should see the following calendar:
        | Teams                 | Mo  | Di  | Mi  | Do  | Fr  | Sa  | So  |
        | Brennstabkessel(B)    |     |     |     |     |     |     |     |
        | Druckwasserreaktor(D) |     |     |     |     |     |     |     |

  Scenario: Edit plan templates of my organization
    Given a plan template exists with name: "Typische Woche", organization: the organization
      And a plan template exists with name: "Typische Osterwoche", organization: the organization

     When I go to the plan templates page for the organization
      And I should see the following table of plan_templates:
        | Name                 | Vorlagentyp    |
        | Typische Osterwoche  | Wochenbasiert  |
        | Typische Woche       | Wochenbasiert  |
     When I follow "Bearbeiten" within the second table row
      And I wait for the modal box to appear
      And I fill in "Name" with "Typische Adventswoche"
      And I press "Speichern"
      And I wait for the modal box to disappear

     Then I should be on the plan templates page for the organization
      And I should see the following table of plan_templates:
        | Name                   | Vorlagentyp    |
        | Typische Adventswoche  | Wochenbasiert  |
        | Typische Osterwoche    | Wochenbasiert  |

