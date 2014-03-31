@javascript
Feature: Active Unavailabilities
  As an employee
  In order to tell my boss about the reason for staying away at a future day
  I want to maintain unavailability entries in a monthly calendar

  Background:
    Given today is 2012-12-21
      And an account exists with name: "Springfield NPP"
      And an organization exists with name: "Sector 7-G", account: the account
      And a confirmed user exists
      And an employee exists with user: the confirmed user, first_name: "Lenny", last_name: "Leonard", account: the account
      And the employee is a member of the organization
      And I am signed in as the confirmed user

  Scenario: Enter a sick day
    Given I am on the dashboard
     When I choose "Verfügbarkeit" from the session and settings menu item
      And I wait for Ember to boot
     Then I should see the following calendar:
         | Mo | Di | Mi | Do | Fr | Sa | So |
         |    |    |    |    |    | 1  | 2  |
         | 3  | 4  | 5  | 6  | 7  | 8  | 9  |
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
         | Mo | Di | Mi | Do | Fr                      | Sa | So |
         |    |    |    |    |                         | 1  | 2  |
         | 3  | 4  | 5  | 6  | 7                       | 8  | 9  |
         | 10 | 11 | 12 | 13 | 14                      | 15 | 16 |
         | 17 | 18 | 19 | 20 | 21 6:00-18:00 Krankheit | 22 | 23 |
         | 24 | 25 | 26 | 27 | 28                      | 29 | 30 |
         | 31 |    |    |    |                         |    |    |
      And an unavailability should exist with reason: "illness"
      And the confirmed user should be the unavailability's user

  Scenario: Changing a sick day to education
    Given an unavailability exists with reason: "illness", user: confirmed user, starts_at: "2012-12-21 6:00", ends_at: "2012-12-21 18:00"
      And I am on the dashboard
     When I choose "Verfügbarkeit" from the session and settings menu item
      And I wait for Ember to boot
      And I follow "6:00-18:00"
      And I wait for the modal box to appear
     Then the "Beginn" field should contain "06:00"
      And the "Ende" field should contain "18:00"
     When I schedule una "8-20"
      And I select "Weiterbildung" from the "Grund" single-select box
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
         | Mo | Di | Mi | Do | Fr                          | Sa | So |
         |    |    |    |    |                             | 1  | 2  |
         | 3  | 4  | 5  | 6  | 7                           | 8  | 9  |
         | 10 | 11 | 12 | 13 | 14                          | 15 | 16 |
         | 17 | 18 | 19 | 20 | 21 8:00-20:00 Weiterbildung | 22 | 23 |
         | 24 | 25 | 26 | 27 | 28                          | 29 | 30 |
         | 31 |    |    |    |                             |    |    |
      And an unavailability should exist with reason: "education"
