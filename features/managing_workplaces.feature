Feature: Managing workplaces
  In order to be able to define shifts and allocate employees
  As a shift manager
  I want to be able to manage workplaces

	Background:
		Given the following workplaces:
			| name |
			| Bar  |

  Scenario: Defining a new workplace
    Given I am on the workplaces index page
    When I follow "Add a new workplace"
    And I fill in "Name" with "Kitchen"
    And I press "Save"
    Then I should see "Workplace successfully created."
    And I should see a workplace named "Kitchen"

  Scenario: Trying to define a workplace with insufficient data
    Given I am on the workplaces index page
    When I follow "Add a new workplace"
    And I fill in "Name" with ""
    And I press "Save"
    Then I should see "Workplace could not be created."
    And I should see "Name can't be blank"
  
	Scenario: Updating an existing workplace
		Given I am on the workplaces index page
		When I follow "Edit"
		And I fill in "Name" with "Reception"
		And I press "Save"
		Then I should see "Workplace successfully updated."
		And I should see a workplace named "Reception"
		And I should not see a workplace named "Bar"

	Scenario: Trying to update an existing workplace with insufficient data
		Given I am on the workplaces index page
		When I follow "Edit"
		And I fill in "Name" with ""
		And I press "Save"
		Then I should see "Workplace could not be updated."
