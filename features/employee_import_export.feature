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

  Scenario: Importing employees from a CSV
    When I go to the employees index page
    And I follow "Import/Export"
    And I follow "Import from CSV"
    And I attach the file at "spec/fixtures/employees.csv" to "File"
    And I press "Import"
    Then I should see the following employees:
      | name             |
      | Fritz Thielemann |
      | Sven Fuchs       |
      | Clemens Kofler   |

  Scenario: Exporting employees as CSV
    Given the following employees for "the account":
      | name             |
      | Fritz Thielemann |
      | Sven Fuchs       |
      | Clemens Kofler   |
    When I go to the employees index page
    And I follow "Import/Export"
    And I follow "Export as CSV"
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
    When I go to the employees index page
    And I follow "Import/Export"
    And I follow "Export blank CSV"
    Then I should get a blank employee CSV file
