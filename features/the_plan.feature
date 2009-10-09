Feature: THE plan
  As a cool guy
  I want to drag + drop shit around
  In order to reach enlightment

  Background:
		Given the following qualifications:
			| name      |
			| Chef      |
			| Barkeeper |
    And the following workplaces:
			| name      |
			| Kitchen   |
			| Bar       |
		And the following employees:
      | name             | initials | qualifications |
      | Clemens Kofler   | CK       | Chef           |
      | Laura Kozlowski  | LK       | Barkeeper      |
		And the following plans:
			| name     | start            | end              |
			| Plan 1   | 2009-09-09 08:00 | 2009-09-12 20:00 |
		And the following shifts:
			| plan   | workplace | requirements        | start            | duration |
			| Plan 1 | Reception | any                 | 2009-09-09 08:00 | 300      |
			| Plan 1 | Kitchen   | Chef:Clemens Kofler | 2009-09-09 09:00 | 240      |
			| Plan 1 | Bar       | Barkeeper           | 2009-09-09 12:00 | 240      |

	Scenario: Viewing a plan
		When I go to the plan show page
		Then I should see a plan named "Plan 1"
		And I should see the following shifts, required qualifications and assignments:
		 | workplace | date       | start | duration | qualifications      |
		 | Reception | 2009-09-09 | 08:00 | 300      | any                 |
		 | Kitchen   | 2009-09-09 | 09:00 | 240      | Chef:Clemens Kofler |
		 | Bar       | 2009-09-09 | 12:00 | 240      | Barkeeper           |
		And I should see an employee named "CK" listed in the sidebar
		And I should see a workplace named "Kitchen" listed in the sidebar
		And I should see a qualification named "Chef" listed in the sidebar
	
	@wip
	Scenario: Adding a requirement to a shift
		Given I am on the plan show page
		When I drag the workplace "Kitchen"
		And I drop onto the shifts area for day 2009-09-10
		Then I should see a shift for the workplace "Kitchen" on 2009-09-10