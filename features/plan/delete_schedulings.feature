Feature: Delete schedulings from plan
  In order to manually move an employee from one day to another
  As a planner
  I want to delete a single scheduling

  Background:
    Given the situation of a nuclear reactor
      And the employee "Lenny" was scheduled in the plan as following:
        | date       | quickie |
        | 2012-12-20 | 7-17    |
        | 2012-12-21 | 2-4     |
        | 2012-12-21 | 5-23    |
      # week 51
      And I am on the employees in week page for the plan for week: 51, cwyear: 2012

      And I should see "07:00-17:00" within the calendar
      And I should see "02:00-04:00" within the calendar
      And I should see "05:00-23:00" within the calendar
      And the employee "Lenny L" should have a grey hours/waz value of "30"

  @javascript
  Scenario: Delete a single scheduling
     When I click on scheduling "5:00-23:00"
      And I wait for the modal box to appear
      And I follow "Löschen" within the modal box
      And I wait for the modal box to disappear
     Then I should see "07:00-17:00" within the calendar
      And I should see "02:00-04:00" within the calendar
      But I should not see "05:00-23:00" within the calendar
      And the employee "Lenny L" should have a grey hours/waz value of "12"
