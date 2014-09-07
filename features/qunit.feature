@javascript
Feature: qUnit testsuite
  In order to avoid running a headless browser
  As a developer
  I want to run all the qunit tests

  Scenario: all
    When I go to the qunit page
    Then I should see "Tests completed"
    Then I should see "0 failed"


