@workplaces
Feature: Managing workplaces
  In order to be able to define shifts and allocate employees
  As a shift manager
  I want to be able to manage workplaces

	Background:
		Given the following workplaces:
			| name |
			| Bar  |

	@white
	Scenario: Listing all workplaces
		Given I am on the start page
		When I follow "Workplaces"
		Then I should see a workplace named "Bar"

	@white
  Scenario: Defining a new workplace
    Given I am on the workplaces index page
    When I follow "Add a new workplace"
    And I fill in "Name" with "Kitchen"
    And I press "Save"
    Then I should see "Workplace successfully created."
    And I should see a workplace named "Kitchen"

	@black
  Scenario: Trying to define a workplace with insufficient data
    Given I am on the workplaces index page
    When I follow "Add a new workplace"
    And I fill in "Name" with ""
    And I press "Save"
    Then I should see "Workplace could not be created."
    And I should see "Name can't be blank"

	@white
	Scenario: Updating an existing workplace
		Given I am on the workplaces index page
		When I follow "Edit"
		And I fill in "Name" with "Reception"
		And I press "Save"
		Then I should see "Workplace successfully updated."
		And I should see a workplace named "Reception"
		And I should not see a workplace named "Bar"

	@black
	Scenario: Trying to update an existing workplace with insufficient data
		Given I am on the workplaces index page
		When I follow "Edit"
		And I fill in "Name" with ""
		And I press "Save"
		Then I should see "Workplace could not be updated."

	@white
	Scenario: Deleting an existing workplace
		Given I am on the workplaces index page
		When I follow "Delete"
		Then I should see "Workplace successfully deleted."
