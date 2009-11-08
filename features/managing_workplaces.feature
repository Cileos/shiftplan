Feature: Managing workplaces
  In order to be able to define shifts and allocate employees
  As a shift manager
  I want to be able to manage workplaces

	Background:
		Given the following users:
		  | name             | email               | password |
		  | Fritz Thielemann | fritz@thielemann.de | oracle   |
		And the following accounts:
			| name        | users               |
			| the account | fritz@thielemann.de |
		And the following workplaces for "the account":
			| name |
			| Bar  |
		And I am logged in with "fritz@thielemann.de" and "oracle"

	Scenario: Listing all workplaces
		Given I am on the start page
		When I follow "Workplaces"
		Then I should see a workplace named "Bar"

  Scenario: Defining a new workplace
    Given I am on the workplaces index page
    When I click on "Click here to add a new workplace"
    And I fill in "Name" with "Kitchen"
    And I press "Save"
    Then I should see a workplace named "Kitchen"

  # Scenario: Trying to define a workplace with insufficient data
  #   Given I am on the workplaces index page
  #   When I click on "Click here to add a new workplace"
  #   And I fill in "Name" with ""
  #   And I press "Save"
  #   Then I should see "can't be blank"

	Scenario: Updating an existing workplace
		Given I am on the workplaces index page
		When I click on the workplace "Bar"
		And I fill in "Name" with "Reception"
		And I press "Save"
		Then I should see a workplace named "Reception"
		And I should not see a workplace named "Bar"
	
	# Scenario: Trying to update an existing workplace with insufficient data
	# 	Given I am on the workplaces index page
	#	  When I click on the workplace "Bar"
	# 	And I fill in "Name" with ""
	# 	And I press "Save"
	# 	Then I should see "Workplace could not be updated."
	
	Scenario: Deleting an existing workplace
		Given I am on the workplaces index page
		When I follow "Delete"
		And I should not see a workplace named "Bar"
