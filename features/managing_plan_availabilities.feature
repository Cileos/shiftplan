Feature: Suitable Employees on Plans
  In order plan shifts more easily
  As a shift manager
  I want to find available employees to assign to shifts/requirements

  Background:
		Given the following users:
		  | name             | email               | password |
		  | Fritz Thielemann | fritz@thielemann.de | oracle   |
		And the following accounts:
			| name        | users               |
			| the account | fritz@thielemann.de |
		And the following qualifications for "the account":
			| name      |
			| Barkeeper |
		And the following employees for "the account":
      | name            | initials |
      | Laura Kozlowski | LK       |
    And the following workplaces for "the account":
			| name      | qualifications    |
			| Bar       | Barkeeper         |
		And the following plans for "the account":
			| name   | start_date | end_date  | start_time | end_time |
			| Plan 1 | Monday     | Wednesday | 8:00       | 20:00    |
    And the following shifts:
      | plan   | workplace | requirements | start         | duration |
      | Plan 1 | Bar       | Barkeeper    | Monday 12:00  | 240      |
		And I am logged in with "fritz@thielemann.de" and "oracle"

  # HIGHLIGHTING A SHIFT

  Scenario: Clicking on a shift highlights the shift
    Given I am on the plan show page
    When I click on the shift "Bar" on Monday
    Then the shift "Bar" on Monday should be highlighted
    When I click on the shift "Bar" on Monday
    Then the shift "Bar" on Monday should not be highlighted

  # HIGHLIGHTING A REQUIREMENT

  Scenario: Clicking on a requirement highlights the requirement
    Given I am on the plan show page
    When I click on the requirement for a "Barkeeper" in the shift "Bar" on Monday
    Then the requirement for a "Barkeeper" in the shift "Bar" on Monday should be highlighted
    When I click on the requirement for a "Barkeeper" in the shift "Bar" on Monday
    Then the requirement for a "Barkeeper" in the shift "Bar" on Monday should not be highlighted


  # AVAILABILITY BY SHIFT
  Scenario: Clicking on a shift where the employee is available
    Given the employee "Laura Kozlowski" is "Available" on Monday
    And I am on the plan show page
    When I click on the shift "Bar" on Monday
    Then the employee "Laura Kozlowski" should be marked as "available"
    And the employee "Laura Kozlowski" should not be marked as "unavailable"
    When I click on the shift "Bar" on Monday
    Then the employee "Laura Kozlowski" should not be marked as "available"

  @sven
  Scenario: Clicking on a shift where the employee is unavailable
    Given the employee "Laura Kozlowski" is "Unavailable" on Monday
    And I am on the plan show page
    When I click on the shift "Bar" on Monday
    Then the employee "Laura Kozlowski" should not be marked as "available"
    And the employee "Laura Kozlowski" should be marked as "unavailable"
    When I click on the shift "Bar" on Monday
    Then the employee "Laura Kozlowski" should not be marked as "unavailable"

  Scenario: Clicking on a shift where the employee's availability is not defined
    Given I am on the plan show page
    When I click on the shift "Bar" on Monday
    Then the employee "Laura Kozlowski" should not be marked as "available"
    And the employee "Laura Kozlowski" should not be marked as "unavailable"


  # AVAILABILITY BY REQUIREMENT

  Scenario: Clicking on a requirement where the employee is available for the shift
    Given the employee "Laura Kozlowski" is "Available" on Monday
    And I am on the plan show page
    When I click on the requirement for a "Barkeeper" in the shift "Bar" on Monday
    Then the employee "Laura Kozlowski" should be marked as "available"
    And the employee "Laura Kozlowski" should not be marked as "unavailable"
    When I click on the requirement for a "Barkeeper" in the shift "Bar" on Monday
    Then the employee "Laura Kozlowski" should not be marked as "available"

  Scenario: Clicking on a requirement where the employee is unavailable for the shift
    Given the employee "Laura Kozlowski" is "Unavailable" on Monday
    And I am on the plan show page
    When I click on the requirement for a "Barkeeper" in the shift "Bar" on Monday
    Then the employee "Laura Kozlowski" should not be marked as "available"
    And the employee "Laura Kozlowski" should be marked as "unavailable"
    When I click on the requirement for a "Barkeeper" in the shift "Bar" on Monday
    Then the employee "Laura Kozlowski" should not be marked as "unavailable"

  Scenario: Clicking on a requirement where the employee's availability for the shift is not defined
    Given I am on the plan show page
    When I click on the requirement for a "Barkeeper" in the shift "Bar" on Monday
    Then the employee "Laura Kozlowski" should not be marked as "available"
    And the employee "Laura Kozlowski" should not be marked as "unavailable"

      
  # # DRAG AND DROP
  # 
  # Scenario: Dragging an employee to a shift where the employee is qualified and available
  #   Given the following employee qualifications and statuses
  #     | name            | qualification | statuses           |
  #     | Laura Kozlowski | Barkeeper     | Monday:Available   |
  #     And I am on the plan show page
  #     When I drag the employee "Laura Kozlowski" over the requirement for a "Barkeeper" in the shift "Bar" on Monday
  #   Then the shift "Bar" on Monday should not be marked unsuitable
  #   And the requirement for a "Barkeeper" on the shift "Bar" on Monday should not be marked unsuitable
  #     
  # Scenario: Dragging an employee to a shift where the employee is qualified and unavailable
  #   Given the following employee qualifications and statuses
  #     | name            | qualification | statuses           |
  #     | Laura Kozlowski | Barkeeper     | Monday:Unavailable |
  #     And I am on the plan show page
  #     When I drag the employee "Laura Kozlowski" over the requirement for a "Barkeeper" in the shift "Bar" on Monday
  #   Then the shift "Bar" on Monday should be marked unsuitable
  #   And the requirement for a "Barkeeper" on the shift "Bar" on Monday should not be marked unsuitable
  #   
  # Scenario: Dragging an employee to a shift where the employee is qualified
  #   Given the following employee qualifications and statuses
  #     | name            | qualification | statuses           |
  #     | Laura Kozlowski | Barkeeper     |                    |
  #     And I am on the plan show page
  #     When I drag the employee "Laura Kozlowski" over the requirement for a "Barkeeper" in the shift "Bar" on Monday
  #   Then the shift "Bar" on Monday should be marked unsuitable
  #   And the requirement for a "Barkeeper" on the shift "Bar" on Monday should not be marked unsuitable
  #   
  # Scenario: Dragging an employee to a shift where the employee is not qualified and available
  #   Given the following employee qualifications and statuses
  #     | name            | qualification | statuses           |
  #     | Laura Kozlowski |               | Monday:Available   |
  #     And I am on the plan show page
  #     When I drag the employee "Laura Kozlowski" over the requirement for a "Barkeeper" in the shift "Bar" on Monday
  #   Then the shift "Bar" on Monday should not be marked unsuitable
  #   And the requirement for a "Barkeeper" on the shift "Bar" on Monday should be marked unsuitable
  #   
  # Scenario: Dragging an employee to a shift where the employee is not qualified and unavailable
  #   Given the following employee qualifications and statuses
  #     | name            | qualification | statuses           |
  #     | Laura Kozlowski |               | Monday:Unavailable |
  #     And I am on the plan show page
  #     When I drag the employee "Laura Kozlowski" over the requirement for a "Barkeeper" in the shift "Bar" on Monday
  #   Then the shift "Bar" on Monday should be marked unsuitable
  #   And the requirement for a "Barkeeper" on the shift "Bar" on Monday should be marked unsuitable
  #   
  # Scenario: Dragging an employee to a shift where the employee is not qualified   
  #   Given the following employee qualifications and statuses
  #     | name            | qualification | statuses           |
  #     | Laura Kozlowski |               |                    |
  #     And I am on the plan show page
  #     When I drag the employee "Laura Kozlowski" over the requirement for a "Barkeeper" in the shift "Bar" on Monday
  #   Then the shift "Bar" on Monday should not be marked unsuitable
  #   And the requirement for a "Barkeeper" on the shift "Bar" on Monday should be marked unsuitable
      