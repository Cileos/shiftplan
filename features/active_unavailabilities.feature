@javascript
Feature: Active Unavailabilities
  As an employee
  In order to tell my boss about the reason for staying away at a future day
  I want to maintain unavailability entries in a monthly calendar


  Scenario: Enter a sick day
    Given today is 2013-03-14
      And an account exists with name: "Springfield NPP"
      And an organization exists with name: "Sector 7-G", account: the account
      And a confirmed user exists
      And an employee exists with user: the confirmed user, first_name: "Lenny", last_name: "Leonard", account: the account
      And the employee is a member of the organization
      And I am signed in as the confirmed user
      And I am on the dashboard
     When I choose "Verfügbarkeit" from the session and settings menu item
     Then I should see the following calendar:
         | Su | Mo | Tu | We | Th | Fr | Sa |
         |    |    |    |    |    |  1 |  2 |
         |  3 |  4 |  5 |  6 |  7 |  8 |  9 |
         | 10 | 11 | 12 | 13 | 14 | 15 | 16 |
         | 17 | 18 | 19 | 20 | 21 | 22 | 23 |
         | 24 | 25 | 26 | 27 | 28 | 29 | 30 |
         | 31 |    |    |    |    |    |    |
     When I follow "21"
      And I wait for the modal box to appear
     #     Then the "Ganztägig" checkbox should be checked
     When I select "Krankheit" from the "Grund" single-select box
     #     And I select "Springfield NPP"
      And I press "Anlegen"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
         | Su | Mo | Tu | We | Th           | Fr | Sa |
         |    |    |    |    |              | 1  | 2  |
         | 3  | 4  | 5  | 6  | 7            | 8  | 9  |
         | 10 | 11 | 12 | 13 | 14           | 15 | 16 |
         | 17 | 18 | 19 | 20 | 21 Krankheit | 22 | 23 |
         | 24 | 25 | 26 | 27 | 28           | 29 | 30 |
         | 31 |    |    |    |              |    |    |
