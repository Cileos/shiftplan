Feature: Manage Teams
  In order to increase the readability of the plan
  As a Planer
  I want to list and edit Teams

  Background:
    Given the situation of a nuclear reactor

  Scenario: Listing all the Teams for my organization
    Given a organization "Government" exists with account: the account "tepco"
      And the following teams exist:
        | organization              | name           |
        | organization "Reactor"    | Reaktor putzen |
        | organization "Reactor"    | Uran rangieren |
        | organization "Reactor"    | Jodausschank   |
        | organization "Government" | Entsorgung     |
      And I am on the page for the organization "Reactor"
     When I follow "Teams"
     Then I should be on the page for teams of the organization "Reactor"
      And I should see the following table of teams:
       | Name           | Kürzel |
       | Jodausschank   | J      |
       | Reaktor putzen | Rp     |
       | Uran rangieren | Ur     |
      But I should not see "Entsorgung"

      And I should see "Um ein neues Team anzulegen"
      And I should see "Sie können ein neues Team auch explizit anlegen, indem Sie auf den Hinzufügen Button klicken"


  Scenario: Modify the color of a team
    Given a team exists with organization: organization: "Reactor"
      And I am on the page for teams of the organization "Reactor"
     When I follow "Bearbeiten"
     Then the "Farbe" field should contain "#"
     When I fill in "Farbe" with "#C83BB4"
      And I press "Team aktualisieren"
     Then I should be on the page for teams of the organization "Reactor"
      And the team color should be "#C83BB4"

  Scenario: Modify the shortcut of a team
    Given a team exists with name: "Uran rangieren", organization: organization: "Reactor"
      And I am on the page for teams of the organization "Reactor"
     When I follow "Bearbeiten"
     Then the "Kürzel" field should contain "Ur"
     When I fill in "Kürzel" with "OK"
      And I press "Team aktualisieren"
     Then I should be on the page for teams of the organization "Reactor"
      And I should see the following table of teams:
       | Name           | Kürzel |
       | Uran rangieren | OK     |

     When I follow "Bearbeiten"
     Then the "Kürzel" field should contain "OK"
