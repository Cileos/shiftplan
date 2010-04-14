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
		And the following qualifications for "the account":
			| name      |
			| Barkeeper |
			| Cook      |
			| Assistant |
		And the following workplaces for "the account":
			| name          | requirements |
			| Cocktail bar  | 2x Barkeeper |
		And I am logged in with "fritz@thielemann.de" and "oracle"

	Scenario: Listing all workplaces
		Given I am on the start page
		When I follow "Manage workplaces"
		Then I should see a workplace named "Cocktail bar"

  Scenario: Defining a new workplace
    Given I am on the workplaces index page
    When I click on "Click here to add a new workplace"
    And I fill in "Name" with "Kitchen"
    And I press "Save"
    Then I should see a workplace named "Kitchen"
    And I should see a flash confirmation

  Scenario: Defining a new workplace and directly assigning requirements
    Given I am on the workplaces index page
    When I click on "Click here to add a new workplace"
    And I fill in "Name" with "Kitchen"
    And I check "Cook"
    And I check "Assistant"
    And I click on the button to add a "Cook"
    And I click on the button to add a "Assistant" 3 times
    And I press "Save"
    Then I should see a workplace named "Kitchen"
    And the workplace named "Kitchen" should have to following workplace requirements:
      | qualification | quantity |
      | Cook          | 2        |
      | Assistant     | 4        |
    And I should see a flash confirmation

  # Scenario: Trying to define a workplace with insufficient data
  #   Given I am on the workplaces index page
  #   When I click on "Click here to add a new workplace"
  #   And I fill in "Name" with ""
  #   And I press "Save"
  #   Then I should see "can't be blank"
  #   And I should see a flash confirmation

	Scenario: Updating an existing workplace
		Given I am on the workplaces index page
		When I click on the workplace "Cocktail bar"
		And I fill in "Name" with "Reception"
		And I press "Save"
		Then I should see a workplace named "Reception"
		And I should not see a workplace named "Cocktail bar"
    And I should see a flash confirmation

  Scenario: Changing requirements for an existing workplace
		Given I am on the workplaces index page
		When I click on the workplace "Cocktail bar"
		And I click on the button to add a "Barkeeper"
		And I press "Save"
    And the workplace named "Cocktail bar" should have to following workplace requirements:
      | qualification | quantity |
      | Barkeeper     | 3        |
		When I click on the workplace "Cocktail bar"
		And I click on the button to remove a "Barkeeper" 2 times
		And I press "Save"
    And the workplace named "Cocktail bar" should have to following workplace requirements:
      | qualification | quantity |
      | Barkeeper     | 1        |
    And I should see a flash confirmation

	# Scenario: Trying to update an existing workplace with insufficient data
	# 	Given I am on the workplaces index page
	#	  When I click on the workplace "Cocktail bar"
	# 	And I fill in "Name" with ""
	# 	And I press "Save"
	# 	Then I should see "Workplace could not be updated."
  #   And I should see a flash confirmation
	
	Scenario: Deleting an existing workplace
		Given I am on the workplaces index page
		When I follow "Delete"
		Then I should not see a workplace named "Cocktail bar"
    And I should see a flash confirmation
