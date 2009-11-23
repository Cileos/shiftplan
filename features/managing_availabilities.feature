Feature: Managing availabilities
  In order to be able to always see when my employees are available on certain days
  As a shift manager
  I want to be able to manage my employees' availabilities

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
    Given I am on the availabilities index page
    When I click on "Fritz Thielemann"
    And I select "23 November 2009" as the date
    And I select "10:00" as the "Start" time
    And I select "22:00" as the "End" time
    And I press "Save"
    Then the employee "Fritz Thielemann" should be available on "23 November 2009" from "10:00" to "22:00"
