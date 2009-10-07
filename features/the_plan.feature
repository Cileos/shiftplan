Feature: THE plan
  In order to reach enlightment
  As a cool guy
  I want to drag + drop shit around

  Background:
		Given the following qualifications:
			| name      |
			| Chef      |
			| Barkeeper |
    Given the following workplaces:
			| name      |
			| Kitchen   |
			| Bar       |
		Given the following employees:
      | name             | qualifications |
      | Clemens Kofler   | Chef           |
      | Laura Kozlowski  | Barkeeper      |
		Given the following shifts:
			| workplace | requirements        | start            | duration |
			| Kitchen   | any                 | 2009-09-09 08:00 | 240      |
			| Kitchen   | Chef:Clemens Kofler | 2009-09-09 09:00 | 240      |
			| Bar       | Barkeeper           | 2009-09-09 12:00 | 240      |

	@wip
	Scenario: Viewing a plan
		When I go to the plans show page
		Then I should see "CK"
