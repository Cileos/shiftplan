@wip
Feature: Managing tags
  In order to be able to tag employees to later search for them
  As a shift manager
  I want to manage tags

	Background:
		Given the following users:
		  | name             | email               | password |
		  | Fritz Thielemann | fritz@thielemann.de | oracle   |
		And the following accounts:
			| name        | users               |
			| the account | fritz@thielemann.de |
		And the following tags for "the account":
			| name       |
			| Location 1 |
		And I am logged in with "fritz@thielemann.de" and "oracle"

	Scenario: Listing all tags
		Given I am on the start page
		When I follow "Tags"
		Then I should see a tag named "Location 1"

  Scenario: Defining a new tag
    Given I am on the tags index page
    When I click on "Click here to add a new tag"
    And I fill in "Name" with "Location 2"
    And I press "Save"
    Then I should see a tag named "Location 2"

	Scenario: Updating an existing tag
		Given I am on the tag index page
		When I click on the tag "Location 1"
		And I fill in "Name" with "Location 3"
		And I press "Save"
		Then I should see a qualification named "Location 3"
		And I should not see a qualification named "Location 1"

	Scenario: Deleting an existing tag
		Given I am on the tags index page
		When I follow "Delete"
		Then I should not see a qualification named "Location 1"
