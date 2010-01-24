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
  	And I am logged in with "fritz@thielemann.de" and "oracle"

  Scenario: Adding an availability entry
    Given I am on the statuses index page
    When I click on "Fritz Thielemann"
    And I select "23 November 2013" as the date
    And I select "10:00" as the "Start" time
    And I select "22:00" as the "End" time
    And I choose "Available"
    And I press "Save"
    Then the employee "Fritz Thielemann" should be available on "23 November 2013" from "10:00" to "22:00"
  
  Scenario: Adding an unavailability entry
    Given I am on the statuses index page
    When I click on "Fritz Thielemann"
    And I select "23 November 2013" as the date
    And I select "10:00" as the "Start" time
    And I select "22:00" as the "End" time
    And I choose "Unavailable"
    And I press "Save"
    Then the employee "Fritz Thielemann" should be unavailable on "23 November 2013" from "10:00" to "22:00"
