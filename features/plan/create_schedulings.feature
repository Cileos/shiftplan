Feature: create a scheduling
  In order for my employees not to miss any of their shifts
  As a planner
  I want to create a scheduling for my employees

  Background:
    Given today is 2012-02-13
      And the situation of a nuclear reactor

  @javascript
  Scenario: through the button on the top
     When I follow "Neue Terminierung"
     Then the "Mo" checkbox should be checked
     When I uncheck "Mo"
      And I check "Mi"
      And I select "Homer S" from "Mitarbeiter"
      And I schedule "9-17"
      And I press "Anlegen"
     Then I should see the following partial calendar:
        | Mitarbeiter    | Mo  | Di  | Mi           | Do  | Fr  | Sa  | So  |
        | Planner Burns  |     |     |              |     |     |     |     |
        | Carl C         |     |     |              |     |     |     |     |
        | Lenny L        |     |     |              |     |     |     |     |
        | Homer S        |     |     | 09:00-17:00  |     |     |     |     |
     And the employee "Homer S" should have a yellow hours/waz value of "8 / 40"

  @javascript
  Scenario: by clicking in a cell and using repetition
     When I click on cell "Do"/"Homer S"
     Then the "Do" checkbox should be checked
     When I uncheck "Do"
      And I check "Mi"
      And I check "Do"
      And I check "Sa"
      And I schedule "22:15-6:45"
      And I press "Anlegen"
     Then I should see the following partial calendar:
        | Mitarbeiter    | Mo  | Di  | Mi           | Do                       | Fr           | Sa           | So           |
        | Planner Burns  |     |     |              |                          |              |              |              |
        | Carl C         |     |     |              |                          |              |              |              |
        | Lenny L        |     |     |              |                          |              |              |              |
        | Homer S        |     |     | 22:15-06:45  | 22:15-06:45 22:15-06:45  | 22:15-06:45  | 22:15-06:45  | 22:15-06:45  |

  @javascript
  Scenario: Entering time span with minutes (15 minute intervals)
     When I click on cell "Di"/"Carl C"
      And I wait for the new scheduling form to appear
     Then the "Startzeit" field should contain ""
      And the "Endzeit" field should contain ""

      # full hour quickie
     When I schedule "9-17"
     Then the "Startzeit" field should contain "09:00"
      And the "Endzeit" field should contain "17:00"

      # minute quickie rounded to 15-minute intervals
     When I schedule "9:16-17:42"
     Then the "Quickie" field should contain "09:15-17:45"
      And the "Startzeit" field should contain "09:15"
      And the "Endzeit" field should contain "17:45"

      # can submit unrounded times, but thay will be rounded on the server side (or invisibly fixed on client)
     When I schedule "9:16-17:42"

     When I press "Anlegen"
      And I wait for the modal box to disappear
     Then I should see the following partial calendar:
        | Mitarbeiter    | Mo  | Di           | Mi  | Do  | Fr  | Sa  | So  |
        | Planner Burns  |     |              |     |     |     |     |     |
        | Carl C         |     | 09:15-17:45  |     |     |     |     |     |
        | Lenny L        |     |              |     |     |     |     |     |
        | Homer S        |     |              |     |     |     |     |     |

  @quickie
  @wip
  @todo
  @javascript
  Scenario: schedule only using the keyboard (Enter, n or a), entering just the timespan, using autocompletion
    Given I wait for the cursor to appear
      And I assume the calendar will not change
     Then the cell "Mo"/"Planner Burns" should be focus
     When I press return
      And I wait for the new scheduling form to appear
      And I schedule "8-18"
      And I press "Anlegen"
      And I wait for the new scheduling form to disappear
     Then I should see the following partial calendar:
        | Mitarbeiter    | Mo           | Di  | Mi  | Do  | Fr  | Sa  | So  |
        | Planner Burns  | 08:00-18:00  |     |     |     |     |     |     |
        | Carl C         |              |     |     |     |     |     |     |
        | Lenny L        |              |     |     |     |     |     |     |
        | Homer S        |              |     |     |     |     |     |     |
      And the cell "Mo"/"Planner Burns" should be focus

    # navigate to another cell and press enter again
     When I press arrow down
      And I press arrow right
     Then the cell "Di"/"Carl C" should be focus
     When I press key "n"
      And I wait for the new scheduling form to appear
      And I schedule "7-17"
      And I press "Anlegen"
      And I wait for the new scheduling form to disappear
     Then I should see the following partial calendar:
        | Mitarbeiter    | Mo           | Di           | Mi  | Do  | Fr  | Sa  | So  |
        | Planner Burns  | 08:00-18:00  |              |     |     |     |     |     |
        | Carl C         |              | 07:00-17:00  |     |     |     |     |     |
        | Lenny L        |              |              |     |     |     |     |     |
        | Homer S        |              |              |     |     |     |     |     |
      And the cell "Di"/"Carl C" should be focus

      # navigate further and use the typeahead
     When I press arrow down
      And I press arrow right
     Then the cell "Mi"/"Lenny L" should be focus
     When I press key "a"
      And I wait for the new scheduling form to appear
      And I schedule "7"
     When I press arrow down in the "Quickie" field
      And I press arrow down in the "Quickie" field
      And I press return in the "Quickie" field
     Then the "Quickie" field should contain "7-17"
      And I press enter in the "Quickie" field
      And I wait for the new scheduling form to disappear
     Then I should see the following partial calendar:
        | Mitarbeiter    | Mo           | Di           | Mi           | Do  | Fr  | Sa  | So  |
        | Planner Burns  | 08:00-18:00  |              |              |     |     |     |     |
        | Carl C         |              | 07:00-17:00  |              |     |     |     |     |
        | Lenny L        |              |              | 07:00-17:00  |     |     |     |     |
        | Homer S        |              |              |              |     |     |     |     |
      And the scheduling "07:00-17:00" should be focus within the cell "Mi"/"Lenny L"

     When I press arrow right
      And I press arrow left
      And I press key "n"
      And I schedule "1-3"
     When I press enter in the "Quickie" field
      And I wait for the new scheduling form to disappear
     Then I should see the following partial calendar:
        | Mitarbeiter    | Mo           | Di           | Mi                       | Do  | Fr  | Sa  | So  |
        | Planner Burns  | 08:00-18:00  |              |                          |     |     |     |     |
        | Carl C         |              | 07:00-17:00  |                          |     |     |     |     |
        | Lenny L        |              |              | 01:00-03:00 07:00-17:00  |     |     |     |     |
        | Homer S        |              |              |                          |     |     |     |     |
      And the cell "Mi"/"Lenny L" should be focus
