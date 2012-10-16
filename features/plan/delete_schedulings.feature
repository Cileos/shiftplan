Feature: Delete schedulings from plan
  In order to manually move an employee from one day to another
  As a planner
  I want to delete a single scheduling

  Background:
    # week 49
    Given today is 2012-12-18
      And the situation of a nuclear reactor
      And the employee "Lenny" was scheduled in the plan as following:
        | date       | quickie |
        | 2012-12-20 | 7-17    |
        | 2012-12-21 | 2-4     |
        | 2012-12-21 | 5-23    |
      And I am on the page for the plan

      And I should see the following calendar:
        | Mitarbeiter | Do   | Fr       |
        | Carl C      |      |          |
        | Lenny L     | 7-17 | 2-4 5-23 |
        | Homer S     |      |          |
      And the employee "Lenny L" should have a grey hours/waz value of "30"

  @javascript
  Scenario: Delete a single scheduling
    Given I click on scheduling "5-23"
      And I wait for the modal box to appear
     Then the "Quickie" field should contain "5-23"
     When I follow "Löschen" within the modal box
     Then the "Quickie" field should contain "5-23" within the new scheduling form within the modal box
      And I should see the following calendar:
        | Mitarbeiter | Do   | Fr  |
        | Carl C      |      |     |
        | Lenny L     | 7-17 | 2-4 |
        | Homer S     |      |     |
      And the employee "Lenny L" should have a grey hours/waz value of "12"

      # Undo / Move
     When I select "Samstag" from "Wochentag" within the new scheduling form within the modal box
      And I press "Anlegen"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
        | Mitarbeiter | Do   | Fr  | Sa   |
        | Carl C      |      |     |      |
        | Lenny L     | 7-17 | 2-4 | 5-23 |
        | Homer S     |      |     |      |
      And the employee "Lenny L" should have a grey hours/waz value of "30"
