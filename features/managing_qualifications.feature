Feature: Managing qualifications
  In order to be able to define shifts and allocate employees
  As a shift manager
  I want to be able to manage qualifications

	Background:
		Given the following users:
		  | name             | email               | password |
		  | Fritz Thielemann | fritz@thielemann.de | oracle   |
		And the following accounts:
			| name        | users               |
			| the account | fritz@thielemann.de |
		And the following qualifications for "the account":
			| name       |
			| Barkeeper  |
		And I am logged in with "fritz@thielemann.de" and "oracle"

	Scenario: Listing all qualifications
		Given I am on the start page
		When I follow "Qualifications"
		Then I should see a qualification named "Barkeeper"

  Scenario: Defining a new qualification
    Given I am on the qualifications index page
    When I click on "Click here to add a new qualification"
    And I fill in "Name" with "Chef"
    And I press "Save"
    Then I should see a qualification named "Chef"

  # Scenario: Trying to define a qualification with insufficient data
  #   Given I am on the qualifications index page
  #   When I click on "Click here to add a new qualification"
  #   And I fill in "Name" with ""
  #   And I press "Save"
  #   Then I should see "can't be blank"

	Scenario: Updating an existing qualification
		Given I am on the qualifications index page
		When I click on the qualification "Barkeeper"
		And I fill in "Name" with "Reception"
		And I press "Save"
		Then I should see a qualification named "Reception"
		And I should not see a qualification named "Barkeeper"
	
	# Scenario: Trying to update an existing qualification with insufficient data
	# 	Given I am on the qualifications index page
	#	  When I click on the qualification "Barkeeper"
	# 	And I fill in "Name" with ""
	# 	And I press "Save"
	# 	Then I should see "qualification could not be updated."

	Scenario: Deleting an existing qualification
		Given I am on the qualifications index page
		When I follow "Delete"
		Then I should not see a qualification named "Barkeeper"
