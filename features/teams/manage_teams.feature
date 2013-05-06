Feature: Manage Teams
  In order to increase the readability of the plan
  As a Planer
  I want to list and edit Teams

  Background:
    Given the situation of a nuclear reactor

  @javascript
  Scenario: Adding a team on the teams page
    Given I am on the page for teams of the organization "Reactor"
     Then I should see "Es existieren noch keine Teams für diese Organisation."
      # help texts
      And I should see "Um ein neues Team implizit anzulegen"
      And I should see "Sie können ein neues Team auch explizit anlegen"
      And I should see "Sie können Teams zusammenlegen, indem"
     When I follow "Hinzufügen"
      And I wait for the modal box to appear
      And I fill in "Name" with "Reaktor putzen"
      And I fill in "Kürzel" with "Rp"
      And I press "Anlegen"
      And I wait for the modal box to disappear
     Then I should be on the page for teams of the organization "Reactor"
      And I should see the following table of teams:
       | Name           | Kürzel |
       | Reaktor putzen | Rp     |
      But I should not see "Es existieren noch keine Teams für diese Organisation."

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
      And I should not see "Es existieren noch keine Teams für diese Organisation."


  @javascript
  Scenario: Modify the color of a team
    Given a team exists with organization: organization: "Reactor"
      And I am on the page for teams of the organization "Reactor"
     When I follow "Bearbeiten"
      And I wait for the modal box to appear
     Then the "Farbe" field should contain "#"
     When I fill in "Farbe" with "#C83BB4"
      And I close all colorpickers
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should be on the page for teams of the organization "Reactor"
      # hex color #C83BB4 is equal to rgb(200, 59, 180)
      # Somehow since the feature runs as a javascript feature the style attribute
      # of the team color sets the background-color to a rgb value.
      And the team color should be "rgb(200, 59, 180)"


  @javascript
  Scenario: Modify the shortcut of a team
    Given a team exists with name: "Uran rangieren", organization: organization: "Reactor"
      And I am on the page for teams of the organization "Reactor"
     When I follow "Bearbeiten"
      And I wait for the modal box to appear
     Then the "Kürzel" field should contain "Ur"
     When I fill in "Kürzel" with "OK"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should be on the page for teams of the organization "Reactor"
      And I should see the following table of teams:
       | Name           | Kürzel |
       | Uran rangieren | OK     |

     When I follow "Bearbeiten"
      And I wait for the modal box to appear
     Then the "Kürzel" field should contain "OK"
