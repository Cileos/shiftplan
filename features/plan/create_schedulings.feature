Feature: create a scheduling
  In order for my employees not to miss any of their shifts
  As a planner
  I want to create a scheduling for my employees

  Background:
    Given today is 2012-02-13
      And the situation of a nuclear reactor


  @javascript
  Scenario: just entering time span
     When I follow "Neue Terminierung"
     Then I should see "9-17 wichtige Arbeit [wA]" within a hint
      And I select "Homer S" from "Mitarbeiter"
      And I select "Mittwoch" from "Wochentag"
      And I fill in "Quickie" with "9-17"
      And I press "Anlegen"
     Then I should see the following calendar:
        | Mitarbeiter   | Montag | Dienstag | Mittwoch | Donnerstag | Freitag | Samstag | Sonntag |
        | Planner Burns |        |          |          |            |         |         |         |
        | Carl C        |        |          |          |            |         |         |         |
        | Lenny L       |        |          |          |            |         |         |         |
        | Homer S       |        |          | 9-17     |            |         |         |         |


  @javascript
  Scenario: just entering time span with javascript
     When I schedule "Homer S" on "Donnerstag" for "8-18"
     Then I should see the following calendar:
        | Mitarbeiter   | Montag | Dienstag | Mittwoch | Donnerstag | Freitag | Samstag | Sonntag |
        | Planner Burns |        |          |          |            |         |         |         |
        | Carl C        |        |          |          |            |         |         |         |
        | Lenny L       |        |          |          |            |         |         |         |
        | Homer S       |        |          |          | 8-18       |         |         |         |

  @javascript
  Scenario: Entering the time span wrong
     When I click on cell "Dienstag"/"Carl C"
      And I wait for the new scheduling form to appear
      And I fill in "Quickie" with "13-"
      And I press "Anlegen"
     Then I should see "Quickie ist nicht gültig" within errors within the new scheduling form

  @javascript
  Scenario: schedule only using the keyboard
     Then the cell "Montag"/"Planner Burns" should be focus
     When I press return
      And I wait for the new scheduling form to appear
      And I fill in "Quickie" with "8-18"
      And I press "Anlegen"
      And I wait for the new scheduling form to disappear
     Then I should see the following calendar:
        | Mitarbeiter   | Montag | Dienstag | Mittwoch | Donnerstag | Freitag | Samstag | Sonntag |
        | Planner Burns | 8-18   |          |          |            |         |         |         |
        | Carl C        |        |          |          |            |         |         |         |
        | Lenny L       |        |          |          |            |         |         |         |
        | Homer S       |        |          |          |            |         |         |         |
      And the cell "Montag"/"Planner Burns" should be focus

    # navigate to another cell and press enter again
     When I press arrow down
      And I press arrow right
     Then the cell "Dienstag"/"Carl C" should be focus
     When I press return
      And I wait for the new scheduling form to appear
      And I fill in "Quickie" with "7-17"
      And I press "Anlegen"
      And I wait for the new scheduling form to disappear
     Then I should see the following calendar:
        | Mitarbeiter   | Montag | Dienstag | Mittwoch | Donnerstag | Freitag | Samstag | Sonntag |
        | Planner Burns | 8-18   |          |          |            |         |         |         |
        | Carl C        |        | 7-17     |          |            |         |         |         |
        | Lenny L       |        |          |          |            |         |         |         |
        | Homer S       |        |          |          |            |         |         |         |
      And the cell "Dienstag"/"Carl C" should be focus

      # navigate further and use the typeahead
     When I press arrow down
      And I press arrow right
     Then the cell "Mittwoch"/"Lenny L" should be focus
     When I press return
      And I wait for the new scheduling form to appear
      And I fill in "Quickie" with "7"
      And I press return in the "Quickie" field
     Then the "Quickie" field should contain "7-17"
     When I press enter in the "Quickie" field
      And I wait for the new scheduling form to disappear
     Then I should see the following calendar:
        | Mitarbeiter   | Montag | Dienstag | Mittwoch | Donnerstag | Freitag | Samstag | Sonntag |
        | Planner Burns | 8-18   |          |          |            |         |         |         |
        | Carl C        |        | 7-17     |          |            |         |         |         |
        | Lenny L       |        |          | 7-17     |            |         |         |         |
        | Homer S       |        |          |          |            |         |         |         |
      And the cell "Mittwoch"/"Lenny L" should be focus
