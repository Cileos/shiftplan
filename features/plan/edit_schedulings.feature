@javascript
Feature: Edit Schedulings of a Plan
  In order to fix typing errors or adapt to new circumstances
  As a planner
  I want to edit schedulings in my plan

  Background:
    Given the situation of a nuclear reactor

  Scenario: Edit a single scheduling
    Given the employee "Lenny" was scheduled in the plan as following:
        | date       | quickie |
        | 2012-12-21 | 7-23:15 |
      And I am on the employees in week page for the plan for cwyear: 2012, week: 51

     When I click on the scheduling "07:00-23:15"
      And I wait for the modal box to appear
      And I choose "Do"
      And I reschedule "1-23:44" and select "Homer S" as "Mitarbeiter"
     Then I should see the following partial calendar:
        | Mitarbeiter    | Do           | Fr  |
        | Planner Burns  |              |     |
        | Carl C         |              |     |
        | Lenny L        |              |     |
        | Homer S        | 01:00-23:45  |     |
      And the employee "Lenny L" should have a grey hours/waz value of "0"
      And the employee "Homer S" should have a yellow hours/waz value of "22¾ / 40"

  Scenario: Edit a scheduling in a cell with multiple schedulings
    Given the employee "Lenny" was scheduled in the plan as following:
        | date       | quickie |
        | 2012-12-21 | 1-3     |
        | 2012-12-21 | 4-10    |
        | 2012-12-21 | 12-23   |
      And I am on the employees in week page for the plan for cwyear: 2012, week: 51
     When I press arrow right 4 times
      And I press arrow down 3 times
     Then the scheduling "04:00-10:00" should be focus within the cell "Fr"/"Lenny L"

     When I press key "e"
     Then I reschedule "4-11" and select "Lenny L" as "Mitarbeiter"
      And I should see the following partial calendar:
        | Mitarbeiter    | Fr                                   |
        | Planner Burns  |                                      |
        | Carl C         |                                      |
        | Lenny L        | 01:00-03:00 04:00-11:00 12:00-23:00  |
        | Homer S        |                                      |
      And the scheduling "04:00-11:00" should be focus within the cell "Fr"/"Lenny L"
