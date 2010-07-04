Feature: Managing plans
  As an admin
  I want to be able to manage plans

	Background:
		Given the following users:
		  | name             | email               | password |
		  | Fritz Thielemann | fritz@thielemann.de | oracle   |
		And the following accounts:
			| name        | subdomain   | users               |
			| the account | the-account | fritz@thielemann.de |
		And the following plans for "the account":
			| name     | start        | end           | template |
			| Plan 1   | Monday 8:00  | Tuesday 20:00 | false    |
			| Template | Monday 10:00 | Tuesday 18:00 | true     |
		And the following qualifications for "the account":
			| name      |
			| Chef      |
			| Barkeeper |
			| Waiter    |
		And the following employees for "the account":
      | name             | initials | qualifications |
      | Clemens Kofler   | CK       | Chef           |
    And the following workplaces for "the account":
			| name      | qualifications    |
			| Kitchen   | Chef              |
			| Bar       | Barkeeper, Waiter |
		And the following shifts:
			| plan     | workplace | requirements        | start         | duration |
			| Template | Reception | any                 | Monday 10:00  | 300      |
			| Template | Kitchen   | Chef:Clemens Kofler | Monday 11:00  | 240      |
			| Template | Bar       | Barkeeper           | Monday 12:00  | 240      |
			| Template | Reception | any                 | Tuesday 10:00 | 300      |
		And I am logged in for "the account" with "fritz@thielemann.de" and "oracle"

	Scenario: Listing all plans
		Given I am on the start page
		When I follow "Plans"
		Then I should see a plan named "Plan 1"

  Scenario: Creating a new plan
    Given I am on the plans index page
    When I fill in "Name" with "Plan 2"
    And I select "Tuesday" as the "plan_start" date
    And I select "Thursday" as the "plan_end" date
    And I select "9:00" as the "plan_start" time
    And I select "12:00" as the "plan_end" time
    And I check "plan_template"
    And I press "Save"
    Then I should see a plan named "Plan 2"
    And the following plans should be stored:
      | name   | start        | end            | template |
      | Plan 2 | Tuesday 9:00 | Thursday 12:00 | true     |
    And I should see a flash confirmation

  @sven
  Scenario: Creating a new plan from a template copying shifts
    Given I am on the plans index page
    When I fill in "Name" with "Plan 2"
    And I select "Monday" as the "plan_start" date
    And I select "Tuesday" as the "plan_end" date
    And I select "10:00" as the "plan_start" time
    And I select "18:00" as the "plan_end" time
    And I select "Template" from "copy_from_id"
    And I check "Shifts"
    And I press "Save"
    Then I should see a plan named "Plan 2"
    And I should see a flash confirmation
		When I follow "Plan 2"
		Then I should see a plan named "Plan 2"
		And I should see the following shifts, required qualifications and assignments:
		 | workplace | date          | duration | qualifications      |
		 | Reception | Monday  10:00 | 300      | any                 |
		 | Kitchen   | Monday  11:00 | 240      | Chef:Clemens Kofler |
		 | Bar       | Monday  12:00 | 240      | Barkeeper           |
		 | Reception | Tuesday 10:00 | 300      | any                 |

  # Scenario: Trying to define a plan with insufficient data
  #   Given I am on the plans index page
  #   When I fill in "Name" with ""
  #   And I press "Save"
  #   Then I should see "Plan could not be created."
  #   And I should see "can't be blank"

  Scenario: Updating an existing plan
    Given I am on the plans index page
    When I follow "edit"
    And I fill in "Name" with "Plan 3"
    And I select "Monday" as the "plan_start" date
    And I select "Tuesday" as the "plan_end" date
    And I select "10:00" as the "plan_start" time
    And I select "18:00" as the "plan_end" time
    And I press "Save"
    Then I should see a plan named "Plan 3"
    And I should see a flash confirmation

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
    And I should see a flash confirmation