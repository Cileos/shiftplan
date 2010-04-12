Feature: Suitable Employees on Plans
  In order plan shifts more easily
  As a shift manager
  I want to find suitable employees to assign to shifts/requirements based on qualifications and availabilities

  Background:
		Given the following users:
		  | name             | email               | password |
		  | Fritz Thielemann | fritz@thielemann.de | oracle   |
		And the following accounts:
			| name        | users               |
			| the account | fritz@thielemann.de |
		And the following qualifications for "the account":
			| name      |
			| Chef      |
			| Barkeeper |
			| Waiter    |
		And the following employees for "the account":
      | name             | initials |
      | Clemens Kofler   | CK       |
      | Laura Kozlowski  | LK       |
      | Sven Fuchs       | SF       |
    And the following workplaces for "the account":
			| name      | qualifications    |
			| Kitchen   | Chef              |
			| Bar       | Barkeeper, Waiter |
		And the following plans for "the account":
			| name   | start_date | end_date  | start_time | end_time |
			| Plan 1 | Monday     | Wednesday | 8:00       | 20:00    |
    And the following shifts:
      | plan   | workplace | requirements        | start         | duration |
      | Plan 1 | Reception | any                 | Monday 08:00  | 300      |
      | Plan 1 | Kitchen   | Chef:Clemens Kofler | Monday 09:00  | 240      |
      | Plan 1 | Bar       | Barkeeper           | Monday 12:00  | 240      |
      | Plan 1 | Reception | any                 | Tuesday 12:00 | 300      |
		And I am logged in with "fritz@thielemann.de" and "oracle"

  # TODO employee drag/drop

  Scenario: Checking for suitable employees for a shift where the employee is qualified and available
    Given I am on the plan show page
    And the following employee qualifications and statuses
      | name            | qualification | statuses           |
      | Laura Kozlowski | Barkeeper     | Monday:Available   |
    When I click on the requirement for a "Barkeeper" in the shift "Bar" on Monday
    Then the requirement for a "Barkeeper" in the shift "Bar" on Monday should be highlighted
    And the employees should present the following statuses:
      | employee        | status     |
      | Laura Kozlowski | suitable   |

  Scenario: Checking for suitable employees for a shift where the employee is qualified and unavailable
    Given I am on the plan show page
    And the following employee qualifications and statuses
      | name            | qualification | statuses           |
      | Laura Kozlowski | Barkeeper     | Monday:Unavailable |
    When I click on the requirement for a "Barkeeper" in the shift "Bar" on Monday
    Then the requirement for a "Barkeeper" in the shift "Bar" on Monday should be highlighted
    And the employees should present the following statuses:
      | employee        | status     |
      | Laura Kozlowski | unsuitable |

  Scenario: Checking for suitable employees for a shift where the employee is qualified
    Given I am on the plan show page
    And the following employee qualifications and statuses
      | name            | qualification | statuses           |
      | Laura Kozlowski | Barkeeper     |                    |
    When I click on the requirement for a "Barkeeper" in the shift "Bar" on Monday
    Then the requirement for a "Barkeeper" in the shift "Bar" on Monday should be highlighted
    And the employees should present the following statuses:
      | employee        | status     |
      | Laura Kozlowski | suitable   |

  Scenario: Checking for suitable employees for a shift where the employee is not qualified and available
    Given I am on the plan show page
    And the following employee qualifications and statuses
      | name            | qualification | statuses           |
      | Laura Kozlowski |               | Monday:Available   |
    When I click on the requirement for a "Barkeeper" in the shift "Bar" on Monday
    Then the requirement for a "Barkeeper" in the shift "Bar" on Monday should be highlighted
    And the employees should present the following statuses:
      | employee        | status     |
      | Laura Kozlowski | unsuitable |

  Scenario: Checking for suitable employees for a shift where the employee is not qualified and unavailable
    Given I am on the plan show page
    And the following employee qualifications and statuses
      | name            | qualification | statuses           |
      | Laura Kozlowski |               | Monday:Unavailable |
    When I click on the requirement for a "Barkeeper" in the shift "Bar" on Monday
    Then the requirement for a "Barkeeper" in the shift "Bar" on Monday should be highlighted
    And the employees should present the following statuses:
      | employee        | status     |
      | Laura Kozlowski | unsuitable |

  Scenario: Checking for suitable employees for a shift where the employee is not qualified
    Given I am on the plan show page
    And the following employee qualifications and statuses
      | name            | qualification | statuses           |
      | Laura Kozlowski |               |                    |
    When I click on the requirement for a "Barkeeper" in the shift "Bar" on Monday
    Then the requirement for a "Barkeeper" in the shift "Bar" on Monday should be highlighted
    And the employees should present the following statuses:
      | employee        | status     |
      | Laura Kozlowski | unsuitable |