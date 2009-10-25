Feature: THE plan
  As a cool guy
  I want to drag + drop shit around
  In order to reach enlightment

  Background:
		Given the following users:
		  | name             | email               | password |
		  | Fritz Thielemann | fritz@thielemann.de | oracle   |
		And the following accounts:
			| name        | users               |
			| the account | fritz@thielemann.de |
		And the following employees:
      | account     | name             | initials | qualifications |
      | the account | Clemens Kofler   | CK       | Chef           |
      | the account | Laura Kozlowski  | LK       | Barkeeper      |
    And the following workplaces:
			| account     | name      |
			| the account | Kitchen   |
			| the account | Bar       |
		And the following qualifications:
			| account     | name      |
			| the account | Chef      |
			| the account | Barkeeper |
		And the following plans:
			| account     | name     | start        | end           |
			| the account | Plan 1   | Monday 08:00 | Tuesday 20:00 |
		And the following shifts:
			| plan   | workplace | requirements        | start        | duration |
			| Plan 1 | Reception | any                 | Monday 08:00 | 300      |
			| Plan 1 | Kitchen   | Chef:Clemens Kofler | Monday 09:00 | 240      |
			| Plan 1 | Bar       | Barkeeper           | Monday 12:00 | 240      |
		And I am logged in with "fritz@thielemann.de" and "oracle"

	Scenario: Viewing a plan
		When I go to the plan show page
		Then I should see a plan named "Plan 1"
		And I should see the following shifts, required qualifications and assignments:
		 | workplace | date   | start | duration | qualifications      |
		 | Reception | Monday | 08:00 | 300      | any                 |
		 | Kitchen   | Monday | 09:00 | 240      | Chef:Clemens Kofler |
		 | Bar       | Monday | 12:00 | 240      | Barkeeper           |
		And I should see an employee named "Clemens Kofler" listed in the sidebar
		And I should see a workplace named "Kitchen" listed in the sidebar
		And I should see a qualification named "Chef" listed in the sidebar

  @wip
	Scenario: Adding a new shift
		Given I am on the plan show page
		When I drag the workplace "Kitchen"
		And I drop onto the shifts area for day Tuesday
		Then I should see a shift "Kitchen" on Tuesday
		And there should be a shift "Kitchen" on Tuesday stored in the database
		
	Scenario: Moving a shift to a different start time
		# can't test this w/ htmlunit
		
	Scenario: Resize a shift to a different start time
		# can't test this w/ htmlunit
	
	# TODO remove existing/new shift
	Scenario: Remove a shift from a shifts collection
		Given I am on the plan show page
		When I drag the shift "Kitchen" on Monday
		And I drop onto the plan area
		Then I should not see a shift "Kitchen" on Monday
		And there should not be a shift "Kitchen" on Monday stored in the database
		
	Scenario: Adding a requirement to a shift
		Given I am on the plan show page
		When I drag the qualification "Chef" 
		And I drop onto to the shift "Bar" on Monday
		Then I should see a requirement for a "Chef" in the shift "Bar" on Monday
		And there should be a requirement for a "Chef" in the shift "Bar" on Monday stored in the database
	
	Scenario: Removing an existing requirement from a shift
		Given I am on the plan show page
		When I drag the requirement for a "Barkeeper" from the shift "Bar" on Monday
		And I drop onto the plan area
		Then I should not see a requirement for a "Barkeeper" in the shift "Bar" on Monday
		And there should not be a requirement for a "Barkeeper" in the shift "Bar" on Monday stored in the database
		
	Scenario: Removing a new requirement from a shift
		Given I am on the plan show page
		When I drag the qualification "Chef" 
		And I drop onto to the shift "Bar" on Monday
		And I drag the requirement for a "Chef" from the shift "Bar" on Monday
		And I drop onto the plan area
		Then I should not see a requirement for a "Chef" in the shift "Bar" on Monday
		And there should not be a requirement for a "Chef" in the shift "Bar" on Monday stored in the database
		
	Scenario: Assigning an employee to an existing requirement
		Given I am on the plan show page
		When I drag the employee "Laura Kozlowski"
		And I drop onto the requirement for a "Barkeeper" in the shift "Bar" on Monday
		And I wait for the animation to finish
		Then I should see the employee "Laura Kozlowski" assigned to the requirement for a "Barkeeper" in the shift "Bar" on Monday
		And the assignment of "Laura Kozlowski" to the requirement for a "Barkeeper" in the shift "Bar" on Monday should be stored in the database
		
	Scenario: Assigning an employee to a new requirement
		Given I am on the plan show page
		When I drag the qualification "Chef" 
		And I drop onto to the shift "Bar" on Monday
		And I drag the employee "Laura Kozlowski"
		And I drop onto the requirement for a "Chef" in the shift "Bar" on Monday
		And I wait for the animation to finish
		Then I should see the employee "Laura Kozlowski" assigned to the requirement for a "Chef" in the shift "Bar" on Monday
		
	Scenario: Removing an existing assignment from an existing requirement
		Given I am on the plan show page
		When I drag the assignment of "Clemens Kofler" from the requirement for a "Chef" in the shift "Kitchen" on Monday
		And I drop onto the plan area
		Then I should not see the employee "Clemens Kofler" assigned to the requirement for a "Chef" in the shift "Kitchen" on Monday
		And the assignment of "Clemens Kofler" to the requirement for a "Chef" in the shift "Kitchen" on Monday should not be stored in the database
		
	Scenario: Removing a new assignment from a new requirement
		Given I am on the plan show page
		When I drag the qualification "Chef" 
		And I drop onto to the shift "Bar" on Monday
		And I drag the employee "Laura Kozlowski"
		And I drop onto the requirement for a "Chef" in the shift "Bar" on Monday
		And I drag the assignment of "Laura Kozlowski" from the requirement for a "Chef" in the shift "Bar" on Monday
		And I drop onto the plan area
		Then I should not see the employee "Laura Kozlowski" assigned to the requirement for a "Chef" in the shift "Bar" on Monday
		And the assignment of "Laura Kozlowski" to the requirement for a "Chef" in the shift "Bar" on Monday should not be stored in the database
		
		
		