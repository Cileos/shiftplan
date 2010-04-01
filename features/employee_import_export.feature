@csv
Feature: Importing and exporting employees
  In order to manage employee data more efficiently
  As a shift manager
  I want to be able to use the import/export functionality

  Background:
    Given the following users:
		  | name             | email               | password |
		  | Fritz Thielemann | fritz@thielemann.de | oracle   |
		And the following accounts:
			| name        | users               |
			| the account | fritz@thielemann.de |
		And I am logged in with "fritz@thielemann.de" and "oracle"

  Scenario: Creating employees by uploading a CSV
    When I go to the start page
    And I follow "Import employees"
    And I attach the file at "spec/fixtures/employees.csv" to "File"
    And I press "Upload"
    Then I should see the following employees:
      | name             |
      | Fritz Thielemann |
      | Sven Fuchs       |
      | Clemens Kofler   |

  Scenario: Updating employees by uploading a CSV
    Given the following employees for "the account":
      | name             | created_at          |
      | Fritz Thielemann | 2010-04-01 22:00:00 |
      | Sven Fuchs       | 2010-04-01 22:00:00 |
      | Clemens Kofler   | 2010-04-01 22:00:00 |
    When I go to the start page
    And I follow "Import employees"
    And I attach the file at "spec/fixtures/employees2.csv" to "File"
    And I press "Upload"
    Then I should see the following employees:
      | name             |
      | Sven-Olof Fuchs  |
    And I should not see the following employees:
      | name       |
      | Sven Fuchs |

  Scenario: Deleting employees by uploading a CSV
    Given the following employees for "the account":
      | name             | created_at          |
      | Fritz Thielemann | 2010-04-01 22:00:00 |
      | Sven Fuchs       | 2010-04-01 22:00:00 |
      | Clemens Kofler   | 2010-04-01 22:00:00 |
    When I go to the start page
    And I follow "Import employees"
    And I attach the file at "spec/fixtures/employees2.csv" to "File"
    And I press "Upload"
    And I should not see the following employees:
      | name           |
      | Clemens Kofler |

  Scenario: Exporting employees as CSV
    Given the following employees for "the account":
      | name             |
      | Fritz Thielemann |
      | Sven Fuchs       |
      | Clemens Kofler   |
    When I go to the start page
    And I follow "Export employees"
    Then I should get a CSV file containing the following employees:
      | name             |
      | Fritz Thielemann |
      | Sven Fuchs       |
      | Clemens Kofler   |

  Scenario: Exporting a blank CSV file
    Given the following employees for "the account":
      | name             |
      | Fritz Thielemann |
      | Sven Fuchs       |
      | Clemens Kofler   |
    When I go to the start page
    And I follow "Template"
    Then I should get a blank employee CSV file
