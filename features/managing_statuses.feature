@status_management
Feature: Managing statuses
  In order to be able to always see when my employees' statuses on certain days
  As a shift manager
  I want to be able to manage my employees' statuses

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
  	And the following statuses:
  	  | employee         | day        | start_time | end_time | status    |
  	  | Fritz Thielemann | 2010-03-23 | 10:00      | 18:00    | Available |
  	And the following default statuses:
  	  | employee         | day of week | start_time | end_time | status    |
  	  | Fritz Thielemann | Monday      | 8:00       | 16:00    | Available |
  	And I am logged in as "fritz@thielemann.de"

  Scenario: Adding an override availability entry
    Given I am on the statuses index page for "Fritz Thielemann" for "March 2010"
    When I select "24 March 2010" as the date
    And I select "10:00" as the "Start" time
    And I select "22:00" as the "End" time
    And I choose "Available"
    And I press "Save"
    Then the employee "Fritz Thielemann" should be available on "24 March 2010" from "10:00" to "22:00"

  Scenario: Adding an override unavailability entry
    Given I am on the statuses index page for "Fritz Thielemann" for "March 2010"
    When I select "24 March 2010" as the date
    And I select "10:00" as the "Start" time
    And I select "22:00" as the "End" time
    And I choose "Unavailable"
    And I press "Save"
    Then the employee "Fritz Thielemann" should be unavailable on "24 March 2010" from "10:00" to "22:00"

  Scenario: Editing an override entry
    Given I am on the statuses index page for "Fritz Thielemann" for "March 2010"
    When I follow "10:00 - 18:00"
    And I choose "Unavailable"
    And I press "Save"
    Then the employee "Fritz Thielemann" should be unavailable on "23 March 2010" from "10:00" to "18:00"

  Scenario: Adding an override availability entry in week view
    Given I am on the statuses index page for week 12 of year 2010
    When I select "Fritz Thielemann" from "Employee"
    And I select "24 March 2010" as the date
    And I select "10:00" as the "Start" time
    And I select "22:00" as the "End" time
    And I choose "Available"
    And I press "Save"
    Then the employee "Fritz Thielemann" should be available on "24 March 2010" from "10:00" to "22:00"

  Scenario: Editing an override entry in week view
    Given I am on the statuses index page for week 12 of year 2010
    When I follow "10:00 - 18:00"
    And I choose "Unavailable"
    And I press "Save"
    Then the employee "Fritz Thielemann" should be unavailable on "23 March 2010" from "10:00" to "18:00"

  Scenario: Adding a default availability entry
    Given I am on the statuses index page for "Fritz Thielemann" for "March 2010"
    # TODO: could be less brittle if I specify the day here, like When I follow "00:00 - 00:00" for "Sunday"
    When I follow "00:00 - 00:00"
    And I select "10:00" as the "Start" time
    And I select "22:00" as the "End" time
    And I choose "Available"
    And I press "Save"
    Then the employee "Fritz Thielemann" should be available on "Sunday" from "10:00" to "22:00"

  Scenario: Adding a default unavailability entry
    Given I am on the statuses index page for "Fritz Thielemann" for "March 2010"
    # TODO: could be less brittle if I specify the day here, like When I follow "00:00 - 00:00" for "Sunday"
    When I follow "00:00 - 00:00"
    And I select "10:00" as the "Start" time
    And I select "22:00" as the "End" time
    And I choose "Unavailable"
    And I press "Save"
    Then the employee "Fritz Thielemann" should be unavailable on "Sunday" from "10:00" to "22:00"

  Scenario: Editing a default entry
    Given I am on the statuses index page for "Fritz Thielemann" for "March 2010"
    When I follow "8:00 - 16:00"
    And I choose "Unavailable"
    And I press "Save"
    Then the employee "Fritz Thielemann" should be unavailable on "Monday" from "08:00" to "16:00"
