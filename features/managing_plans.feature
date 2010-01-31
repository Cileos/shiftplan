Feature: Managing plans
  As an admin
  I want to be able to manage plans

	Background:
		Given the following users:
		  | name             | email               | password |
		  | Fritz Thielemann | fritz@thielemann.de | oracle   |
		And the following accounts:
			| name        | users               |
			| the account | fritz@thielemann.de |
		And the following plans for "the account":
			| name   | start_date | end_date | start_time | end_time | template |
			| Plan 1 | Monday     | Tuesday  | 8:00       | 20:00    | false    |
		And I am logged in with "fritz@thielemann.de" and "oracle"

	Scenario: Listing all plans
		Given I am on the start page
		When I follow "Plans"
		Then I should see a plan named "Plan 1"

  @wip
  Scenario: Creating a new plan
    Given I am on the plans index page
    When I fill in "Name" with "Plan 2"
    And I select "Tuesday" as the "plan_start_date" date
    And I select "Thursday" as the "plan_end_date" date
    And I select "9:00" as the "plan_start_time" time
    And I select "12:00" as the "plan_end_time" time
    And I check "Template"
    And I press "Save"
    Then I should see a plan named "Plan 2"
    And the following plans should be stored:
      | name   | start_date | end_date | start_time| end_time | template |
      | Plan 2 | Tuesday    | Thursday | 9:00      | 12:00    | true     |

  # Scenario: Trying to define a plan with insufficient data
  #   Given I am on the plans index page
  #   When I fill in "Name" with ""
  #   And I press "Save"
  #   Then I should see "Plan could not be created."
  #   And I should see "can't be blank"

  Scenario: Updating an existing plan
    Given I am on the plans index page
    When I follow "Edit"
    And I fill in "Name" with "Plan 3"
    And I press "Save"
    Then I should see a plan named "Plan 3"
  
	# Scenario: Trying to update an existing plan with insufficient data
	# 	Given I am on the employees index page
	# 	When I follow "Edit"
	# 	And I fill in "Name" with ""
	# 	And I press "Save"
	# 	Then I should see "Plan could not be updated."
	#     And I should see "can't be blank"
  
  Scenario: Deleting an existing plan
    Given I am on the plans index page
    When I follow "Delete"
    Then I should not see a plan named "Plan 1"
