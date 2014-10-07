@javascript
Feature: Unavailable because of long vacation
  As an employee
  I want to fill in my rare 2 week vacations in one sweep
  In order no to have to fill in every day by itself

  Background:
    Given an account "Work" exists with name: "Springfield NPP"
      And an organization exists with name: "Sector 7-G", account: the account
      And a confirmed user exists
      And an employee "Homer" exists with user: the confirmed user, first_name: "Homer", last_name: "S.", account: the account
      And the employee is a member of the organization
      And I am signed in as the confirmed user

  Scenario: 2 week vacation (surrounding today)
    Given I am on my availability page for year: 2012, month: 12
      And I wait for Ember to boot
     When I follow "21"
      And I wait for the modal box to appear
      And I select "Urlaub" from "Grund"
      And I pick "10. Dezember 2012" from "Erster Tag"
      And I pick "23. Dezember 2012" from "Letzter Tag"
      And I press "Anlegen"
      And I wait for the spinner to disappear
     Then 14 unavailabilities should exist
      And I should see "Ganztägig Urlaub"
      And I should see the following calendar:
         | Mo                  | Di                  | Mi                  | Do                  | Fr                  | Sa                  | So                  |
         |                     |                     |                     |                     |                     | 1                   | 2                   |
         | 3                   | 4                   | 5                   | 6                   | 7                   | 8                   | 9                   |
         | 10 Ganztägig Urlaub | 11 Ganztägig Urlaub | 12 Ganztägig Urlaub | 13 Ganztägig Urlaub | 14 Ganztägig Urlaub | 15 Ganztägig Urlaub | 16 Ganztägig Urlaub |
         | 17 Ganztägig Urlaub | 18 Ganztägig Urlaub | 19 Ganztägig Urlaub | 20 Ganztägig Urlaub | 21 Ganztägig Urlaub | 22 Ganztägig Urlaub | 23 Ganztägig Urlaub |
         | 24                  | 25                  | 26                  | 27                  | 28                  | 29                  | 30                  |
         | 31                  |                     |                     |                     |                     |                     |                     |
