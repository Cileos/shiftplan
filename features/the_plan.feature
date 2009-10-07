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
			| Plan 1 | Kitchen   | any                 | 2009-09-09 08:00 | 240      |
			| Plan 1 | Kitchen   | Chef:Clemens Kofler | 2009-09-09 09:00 | 240      |
			| Plan 1 | Bar       | Barkeeper           | 2009-09-09 12:00 | 240      |

	@wip
	Scenario: Viewing a plan
		When I go to the plans show page
		Then I should see "CK"
