Feature: THE plan
  In order to reach enlightment
  As a cool guy
  I want to drag + drop shit around

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
      | name             | qualifications |
      | Clemens Kofler   | Chef           |
      | Laura Kozlowski  | Barkeeper      |
		And the following plans:
			| name     | start            | end              |
			| Plan 1   | 2009-09-09 08:00 | 2009-09-12 20:00 |
		And the following shifts:
			| plan   | workplace | requirements        | start            | duration |
			| Plan 1 | Reception | any                 | 2009-09-09 08:00 | 300      |
			| Plan 1 | Kitchen   | Chef:Clemens Kofler | 2009-09-09 09:00 | 240      |
			| Plan 1 | Bar       | Barkeeper           | 2009-09-09 12:00 | 240      |

	@wip
	Scenario: Viewing a plan
		When I go to the plans show page
		Then I should see a plan named "Plan 1"
		And I should see a shift for the Reception on 2009-09-09, starting at 08:00, lasting 300 minutes, containing 1 requirement for any qualification
		And I should see a shift for the Kitchen on 2009-09-09, starting at 09:00, lasting 240 minutes, containing 1 requirement for a Chef and an assignment for Clemens Kofler
		And I should see a shift for the Bar on 2009-09-09, starting at 12:00, lasting 240 minutes, containing 1 requirement for a Barkeeper
		And I should see an employee named "CK" listed in the sidebar
		And I should see a workplace named "Kitchen" listed in the sidebar
		And I should see a qualification named "Chef" listed in the sidebar
