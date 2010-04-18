@status_management
Feature: Managing default statuses
  In order to be able to always see when my employees are usually available or unavailable
  As a shift manager
  I want to be able to manage my employees' default statuses

	Background:
    Given the following users:
  	  | name             | email               | password |
  	  | Fritz Thielemann | fritz@thielemann.de | oracle   |
  	And the following accounts:
  		| name        | users               |
  		| the account | fritz@thielemann.de |
  	And the following employees for "the account":
  		| name 							|
  		| Fritz Thielemann  |
  	And the following default statuses:
  	  | employee         | day of week | start_time | end_time | status    |
  	  | Fritz Thielemann | Tuesday     | 8:00       | 16:00    | Available |
  	And I am logged in as "fritz@thielemann.de"

  Scenario: Adding an availability entry
    Given I am on the default statuses index page
    When I select "Fritz Thielemann" from "Employee"
    And I select "Monday" from "Day of week"
    And I select "10:00" as the "Start" time
    And I select "22:00" as the "End" time
    And I choose "Available"
    And I press "Save"
    Then the employee "Fritz Thielemann" should be available on "Monday" from "10:00" to "22:00"

  Scenario: Adding an unavailability entry
    Given I am on the default statuses index page
    When I select "Fritz Thielemann" from "Employee"
    And I select "Monday" from "Day of week"
    And I select "10:00" as the "Start" time
    And I select "22:00" as the "End" time
    And I choose "Unavailable"
    And I press "Save"
    Then the employee "Fritz Thielemann" should be unavailable on "Monday" from "10:00" to "22:00"

  Scenario: Editing a status entry
    Given I am on the default statuses index page
    When I click on "08:00 - 16:00"
    And I choose "Unavailable"
    And I press "Save"
    Then the employee "Fritz Thielemann" should be unavailable on "Tuesday" from "08:00" to "16:00"
