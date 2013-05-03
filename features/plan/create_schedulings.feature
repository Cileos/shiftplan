Feature: create a scheduling
  In order for my employees not to miss any of their shifts
  As a planner
  I want to create a scheduling for my employees

  Background:
    Given today is 2012-02-13
      And the situation of a nuclear reactor
      And I inject style "position:relative" into "header"

  @javascript
  Scenario: through the button on the top
     When I follow "Neue Terminierung"
     Then I should see "9-17 wichtige Arbeit [wA]" within a hint
      And I select "Homer S" from "Mitarbeiter"
      And I select "Mittwoch" from "Wochentag"
      And I fill in "Quickie" with "9-17"
      And I press "Anlegen"
     Then I should see the following partial calendar:
        | Mitarbeiter  | Mo  | Di  | Mi           | Do  | Fr  | Sa  | So  |
        | Carl C       |     |     |              |     |     |     |     |
        | Lenny L      |     |     |              |     |     |     |     |
        | Homer S      |     |     | 09:00-17:00  |     |     |     |     |
     And the employee "Homer S" should have a yellow hours/waz value of "8 / 40"

     # completion
     When I inject style "position:relative" into "header"
      And I follow "Neue Terminierung"
      And I select "Lenny L" from "Mitarbeiter"
      And I select "Mittwoch" from "Wochentag"
      And I fill in "Quickie" with "9"
      And I wait for the completion list to appear
      And I press arrow down in the "Quickie" field
      And I press return in the "Quickie" field
     Then the "Quickie" field should contain "9-17"

  @javascript
  Scenario: through the button on the top with repeating for checked days
     When I follow "Neue Terminierung"
      And I select "Homer S" from "Mitarbeiter"
     Then the "Mittwoch" checkbox should not be checked
      And the "Donnerstag" checkbox should not be checked
     When I select "Mittwoch" from "Wochentag"
     Then the "Mittwoch" checkbox should be checked
     When I check "Donnerstag"
      And I fill in "Quickie" with "9-17"
      And I press "Anlegen"
     Then I should see the following partial calendar:
        | Mitarbeiter | Mo | Di | Mi          | Do          | Fr | Sa | So |
        | Carl C      |    |    |             |             |    |    |    |
        | Lenny L     |    |    |             |             |    |    |    |
        | Homer S     |    |    | 09:00-17:00 | 09:00-17:00 |    |    |    |
     # TODO: editing
     # When I click on cell "Mi"/"Homer S"
     # Then the "Mittwoch" checkbox should be checked
     #  And the "Donnerstag" checkbox should not be checked
     # When I check "Freitag"
     #  And I press "Speichern"
     # Then I should see the following partial calendar:
     #    | Mitarbeiter | Mo | Di | Mi          | Do          | Fr          | Sa | So |
     #    | Carl C      |    |    |             |             |             |    |    |
     #    | Lenny L     |    |    |             |             |             |    |    |
     #    | Homer S     |    |    | 09:00-17:00 | 09:00-17:00 | 09:00-17:00 |    |    |

  @javascript
  Scenario: Entering the time span wrong
     When I click on cell "Di"/"Carl C"
      And I wait for the new scheduling form to appear
      And I fill in "Quickie" with "13-"
      And I press "Anlegen"
     Then I should see "Quickie ist nicht gültig" within errors within the new scheduling form

  @todo
  @javascript
  Scenario: schedule only using the keyboard (Enter, n or a), entering just the timespan, using autocompletion
    Given I wait for the cursor to appear
      And I assume the calendar will not change
     Then the cell "Mo"/"Carl C" should be focus
     When I press return
      And I wait for the new scheduling form to appear
     Then I should see "9-17 wichtige Arbeit [wA]" within a hint
     When I fill in "Quickie" with "8-18"
      And I press "Anlegen"
      And I wait for the new scheduling form to disappear
     Then I should see the following partial calendar:
        | Mitarbeiter  | Mo           | Di  | Mi  | Do  | Fr  | Sa  | So  |
        | Carl C       | 08:00-18:00  |     |     |     |     |     |     |
        | Lenny L      |              |     |     |     |     |     |     |
        | Homer S      |              |     |     |     |     |     |     |
      And the cell "Mo"/"Carl C" should be focus

    # navigate to another cell and press enter again
     When I press arrow down
      And I press arrow right
     Then the cell "Di"/"Lenny L" should be focus
     When I press key "n"
      And I wait for the new scheduling form to appear
      And I fill in "Quickie" with "7-17"
      And I press "Anlegen"
      And I wait for the new scheduling form to disappear
     Then I should see the following partial calendar:
        | Mitarbeiter  | Mo           | Di           | Mi  | Do  | Fr  | Sa  | So  |
        | Carl C       | 08:00-18:00  |              |     |     |     |     |     |
        | Lenny L      |              | 07:00-17:00  |     |     |     |     |     |
        | Homer S      |              |              |     |     |     |     |     |
      And the cell "Di"/"Lenny L" should be focus

      # navigate further and use the typeahead
     When I press arrow down
      And I press arrow right
     Then the cell "Mi"/"Homer S" should be focus
     When I press key "a"
      And I wait for the new scheduling form to appear
      And I fill in "Quickie" with "7"
     When I press arrow down in the "Quickie" field
      And I press arrow down in the "Quickie" field
      And I press return in the "Quickie" field
     Then the "Quickie" field should contain "7-17"
      And I press enter in the "Quickie" field
      And I wait for the new scheduling form to disappear
     Then I should see the following partial calendar:
        | Mitarbeiter  | Mo           | Di           | Mi           | Do  | Fr  | Sa  | So  |
        | Carl C       | 08:00-18:00  |              |              |     |     |     |     |
        | Lenny L      |              | 07:00-17:00  |              |     |     |     |     |
        | Homer S      |              |              | 07:00-17:00  |     |     |     |     |
      And the scheduling "07:00-17:00" should be focus within the cell "Mi"/"Homer S"

     When I press arrow right
      And I press arrow left
      And I press key "n"
      And I fill in "Quickie" with "1-3"
     When I press enter in the "Quickie" field
      And I wait for the new scheduling form to disappear
     Then I should see the following partial calendar:
        | Mitarbeiter  | Mo           | Di           | Mi                       | Do  | Fr  | Sa  | So  |
        | Carl C       | 08:00-18:00  |              |                          |     |     |     |     |
        | Lenny L      |              | 07:00-17:00  |                          |     |     |     |     |
        | Homer S      |              |              | 01:00-03:00 07:00-17:00  |     |     |     |     |
      And the cell "Mi"/"Homer S" should be focus
