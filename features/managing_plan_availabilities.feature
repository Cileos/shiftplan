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
			| Chef      |
		And the following employees for "the account":
      | name             | initials | qualifications    |
      | Laura Kozlowski  | LK       |                   |
      | Fritz Thielemann | FT       | Chef              |
    And the following workplaces for "the account":
			| name      | qualifications    |
			| Bar       | Barkeeper         |
			| Kitchen   | Chef              |
		And the following plans for "the account":
			| name   | start       | end             |
			| Plan 1 | Monday 8:00 | Wednesday 20:00 |
    And the following shifts:
      | plan   | workplace | requirements | start         | duration |
      | Plan 1 | Bar       | Barkeeper    | Monday 12:00  | 240      |
      | Plan 1 | Kitchen   | Chef         | Monday 12:00  | 240      |
		# And I am logged in with "fritz@thielemann.de" and "oracle"
		And I am logged in as "fritz@thielemann.de"

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


  # QUALIFICATION BY SHIFT
  Scenario: Clicking on a shift where the employee is qualified
    Given the employee "Laura Kozlowski" is qualified as a "Barkeeper"
    And I am on the plan show page
    When I click on the shift "Bar" on Monday
    Then the employee "Laura Kozlowski" should be marked as "qualified"
    And the employee "Laura Kozlowski" should not be marked as "unqualified"
    When I click on the shift "Bar" on Monday
    Then the employee "Laura Kozlowski" should not be marked as "qualified"

  Scenario: Clicking on a shift where the employee is not qualified
    Given the employee "Laura Kozlowski" is not qualified as a "Barkeeper"
    And I am on the plan show page
    When I click on the shift "Bar" on Monday
    Then the employee "Laura Kozlowski" should be marked as "unqualified"
    And the employee "Laura Kozlowski" should not be marked as "qualified"
    When I click on the shift "Bar" on Monday
    Then the employee "Laura Kozlowski" should not be marked as "unqualified"


  # QUALIFICATION BY REQUIREMENT
  Scenario: Clicking on a shift where the employee is qualified
    Given the employee "Laura Kozlowski" is qualified as a "Barkeeper"
    And I am on the plan show page
    When I click on the requirement for a "Barkeeper" in the shift "Bar" on Monday
    Then the employee "Laura Kozlowski" should be marked as "qualified"
    And the employee "Laura Kozlowski" should not be marked as "unqualified"
    When I click on the requirement for a "Barkeeper" in the shift "Bar" on Monday
    Then the employee "Laura Kozlowski" should not be marked as "qualified"

  Scenario: Clicking on a shift where the employee is not qualified
    Given the employee "Laura Kozlowski" is not qualified as a "Barkeeper"
    And I am on the plan show page
    When I click on the requirement for a "Barkeeper" in the shift "Bar" on Monday
    Then the employee "Laura Kozlowski" should be marked as "unqualified"
    And the employee "Laura Kozlowski" should not be marked as "qualified"
    When I click on the requirement for a "Barkeeper" in the shift "Bar" on Monday
    Then the employee "Laura Kozlowski" should not be marked as "unqualified"


  # AVAILABILITY BY SHIFT

  Scenario: Clicking on a shift where the employee is available
    Given the employee "Laura Kozlowski" is "Available" from "12:00" to "18:00" on Monday
    And I am on the plan show page
    When I click on the shift "Bar" on Monday
    Then the employee "Laura Kozlowski" should be marked as "available"
    And the employee "Laura Kozlowski" should not be marked as "unavailable"
    When I click on the shift "Bar" on Monday
    Then the employee "Laura Kozlowski" should not be marked as "available"

  # TEMPORARY: disabled status/availability management
  Scenario: Clicking on a shift where the employee is unavailable
    Given the employee "Laura Kozlowski" is "Unavailable" from "12:00" to "18:00" on Monday
    And I am on the plan show page
    When I click on the shift "Bar" on Monday
    Then the employee "Laura Kozlowski" should be marked as "available"
    And the employee "Laura Kozlowski" should not be marked as "unavailable"
    When I click on the shift "Bar" on Monday
    Then the employee "Laura Kozlowski" should not be marked as "unavailable"

  Scenario: Clicking on a shift where the employee's availability is not defined
    Given I am on the plan show page
    When I click on the shift "Bar" on Monday
    Then the employee "Laura Kozlowski" should be marked as "available"
    And the employee "Laura Kozlowski" should not be marked as "unavailable"

  # TEMPORARY: disabled status/availability management
  # Scenario: Clicking on a shift where the employee is unavailable
  #   Given the employee "Laura Kozlowski" is "Unavailable" from "12:00" to "18:00" on Monday
  #   And I am on the plan show page
  #   When I click on the shift "Bar" on Monday
  #   Then the employee "Laura Kozlowski" should not be marked as "available"
  #   And the employee "Laura Kozlowski" should be marked as "unavailable"
  #   When I click on the shift "Bar" on Monday
  #   Then the employee "Laura Kozlowski" should not be marked as "unavailable"
  # 
  # Scenario: Clicking on a shift where the employee's availability is not defined
  #   Given I am on the plan show page
  #   When I click on the shift "Bar" on Monday
  #   Then the employee "Laura Kozlowski" should not be marked as "available"
  #   And the employee "Laura Kozlowski" should not be marked as "unavailable"


  # AVAILABILITY BY REQUIREMENT

  Scenario: Clicking on a requirement where the employee is available for the shift
    Given the employee "Laura Kozlowski" is "Available" on Monday
    And I am on the plan show page
    When I click on the requirement for a "Barkeeper" in the shift "Bar" on Monday
    Then the employee "Laura Kozlowski" should be marked as "available"
    And the employee "Laura Kozlowski" should not be marked as "unavailable"
    When I click on the requirement for a "Barkeeper" in the shift "Bar" on Monday
    Then the employee "Laura Kozlowski" should not be marked as "available"

  # TEMPORARY: disabled status/availability management
  Scenario: Clicking on a requirement where the employee is unavailable for the shift
    Given the employee "Laura Kozlowski" is "Unavailable" on Monday
    And I am on the plan show page
    When I click on the requirement for a "Barkeeper" in the shift "Bar" on Monday
    Then the employee "Laura Kozlowski" should be marked as "available"
    And the employee "Laura Kozlowski" should not be marked as "unavailable"
    When I click on the requirement for a "Barkeeper" in the shift "Bar" on Monday
    Then the employee "Laura Kozlowski" should not be marked as "unavailable"

  Scenario: Clicking on a requirement where the employee's availability for the shift is not defined
    Given I am on the plan show page
    When I click on the requirement for a "Barkeeper" in the shift "Bar" on Monday
    Then the employee "Laura Kozlowski" should be marked as "available"
    And the employee "Laura Kozlowski" should not be marked as "unavailable"

  # TEMPORARY: disabled status/availability management
  # Scenario: Clicking on a requirement where the employee is unavailable for the shift
  #   Given the employee "Laura Kozlowski" is "Unavailable" on Monday
  #   And I am on the plan show page
  #   When I click on the requirement for a "Barkeeper" in the shift "Bar" on Monday
  #   Then the employee "Laura Kozlowski" should not be marked as "available"
  #   And the employee "Laura Kozlowski" should be marked as "unavailable"
  #   When I click on the requirement for a "Barkeeper" in the shift "Bar" on Monday
  #   Then the employee "Laura Kozlowski" should not be marked as "unavailable"
  # 
  # Scenario: Clicking on a requirement where the employee's availability for the shift is not defined
  #   Given I am on the plan show page
  #   When I click on the requirement for a "Barkeeper" in the shift "Bar" on Monday
  #   Then the employee "Laura Kozlowski" should not be marked as "available"
  #   And the employee "Laura Kozlowski" should not be marked as "unavailable"

      
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
      