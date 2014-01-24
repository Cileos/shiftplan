Feature: Suspended employees on Plan
  In order to limit the length of the list and table of employees
  I want to only see employees who are planable (not suspended Membership)
  Unless the employee is already scheduled in this week

  Background:
    Given today is 2012-02-13
      And the situation of a nuclear reactor
      And "Lenny" was suspended from "Reactor"

  Scenario: suspended employee is hidden when scheduled in another week
    Given the employee "Lenny" was scheduled in the plan as following:
        | date       | quickie |
        | 2012-02-10 | 7-23    |
    Given I am on the page of the plan
     Then I should see "Homer" within the calendar
      But I should not see "Lenny" within the calendar


  Scenario: suspended employee is shown when scheduled THIS WEEK
    Given the employee "Lenny" was scheduled in the plan as following:
        | date       | quickie |
        | 2012-02-14 | 7-23    |
      And I am on the page of the plan
     Then I should see "Homer" within the calendar
      And I should see "Lenny" within ".employee.suspended" within the calendar
      And I should see "07:00-23:00" within the calendar
