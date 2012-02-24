Feature: Manage Teams
  In order to increase the readability of the plan
  As a Planer
  I want to list and edit Teams

  Background:
    Given the situation of a nuclear reactor

  Scenario: Listing all the Teams for my organization
    Given a organization "Government" exists
      And the following teams exist:
        | organization              | name           |
        | organization "Reactor"    | Reaktor putzen |
        | organization "Reactor"    | Uran rangieren |
        | organization "Reactor"    | Jodausschank   |
        | organization "Government" | Entsorgung     |
     When I follow "Teams"
     Then I should the following table of teams:
       | Name           | Kürzel |
       | Jodausschank   | J      |
       | Reaktor putzen | Rp     |
       | Uran rangieren | Ur     |
      But I should not see "Entsorgung"


  @todo
  Scenario: Modify the color of a team

  Scenario: Modify the shortcut of a team
    Given a team exists with name: "Uran rangieren", organization: organization: "Reactor"
     When I follow "Teams"
      And I follow "Bearbeiten"
     Then the "Kürzel" field should contain "Ur"
     When I fill in "Kürzel" with "OK"
      And I press "Team aktualisieren"
     Then I should the following table of teams:
       | Name           | Kürzel |
       | Uran rangieren | OK     |

     When I follow "Bearbeiten"
     Then the "Kürzel" field should contain "OK"
