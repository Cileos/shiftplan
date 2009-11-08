Feature: Managing employees
  In order to be able to define shifts and allocate employees
  As a shift manager
  I want to be able to manage employees

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

	Scenario: Listing all employees
		Given I am on the start page
		When I follow "Employees"
		Then I should see an employee named "Fritz Thielemann"

  Scenario: Defining a new employee
    Given I am on the employees index page
    When I click on "Click here to add a new employee"
    And I fill in "First name" with "Clemens"
    And I fill in "Last name" with "Kofler"
    And I press "Save"
    Then I should see an employee named "Clemens Kofler"

  # Scenario: Trying to define an employee with insufficient data
  #   Given I am on the employees index page
  #   When I click on "Click here to add a new employee"
  #   And I fill in "First name" with ""
  #   And I fill in "Last name" with "Kofler"
  #   And I press "Save"
  #   Then I should see "Employee could not be created."
  #   And I should see "can't be blank"

	Scenario: Updating an existing employee
		Given I am on the employees index page
		When I click on the employee "Fritz Thielemann"
		And I fill in "First name" with "Laura"
		And I fill in "Last name" with "Kozlowski"
		And I press "Save"
		Then I should see an employee named "Laura Kozlowski"
		And I should not see an employee named "Fritz Thielemann"

	# Scenario: Trying to update an existing employee with insufficient data
	# 	Given I am on the employees index page
	#   When I click on the employee "Fritz Thielemann"
	# 	And I fill in "Last name" with ""
	# 	And I press "Save"
	# 	Then I should see "Employee could not be updated."

	Scenario: Deleting an existing employee
		Given I am on the employees index page
		When I follow "Delete"
		Then I should not see an employee named "Fritz Thielemann"
