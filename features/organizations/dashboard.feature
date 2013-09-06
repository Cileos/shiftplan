Feature: Organisation Dashboard
  In order to never loose control over my organization
  As a planner, owner, and employee
  I want to get a clean overview about the happenings in my organization

  Background:
    Given the situation of a nuclear reactor
      And today is 2012-12-04 06:00

  Scenario: Lists recent notifications
    Given a notification exists with employee: the employee "Burns"
     When I go to the page for the organization
     Then I should see "You did something awesome"

  Scenario: List upcoming schedulings
    Given the employee "Burns" was scheduled in the plan as following:
        | week | cwday | quickie                         |
        | 49   | 2     | 9-17 Reaktor Putzen [RP]        |
        | 50   | 3     | 10-18 Reaktor Fegen [RF]        |
        | 51   | 2     | 22-23 Verantwortung tragen [Vt] |
      And an organization "Illuminaten" exists
      And the employee "Burns" is a member of the organization "Illuminaten"
      And a plan "Secret Meetings" exists with organization: organization "Illuminaten"
      And the employee "Burns" was scheduled in the plan "Secret Meetings" as following:
        | week | cwday | quickie          |
        | 49   | 2     | 17-23 Illuminate |
     When I go to the page for the organization "Reactor"
     Then I should see an agenda table with the following rows:
       | day | day-name | month-year | time    | team                | plan                               |
       | 4   | Di       | Dez 2012   | 9 - 17  | Reaktor Putzen [RP] | Cleaning the Reactor |
       | 12  | Mi       | Dez 2012   | 10 - 18 | Reaktor Fegen [RF]  | Cleaning the Reactor |
      But I should not see "22 - 23" within the schedulings module
      And I should not see "Verantwortung tragen" within the schedulings module
      And I should not see "Illuminate" within the schedulings module
     When I follow "Reaktor Putzen [RP]" within the schedulings module
     Then I should be somewhere under the page of the plan "clean reactor"

  Scenario: List recent news posts
    Given a blog "Radiation" exists with organization: the organization "Reactor"
      And an organization "Food" exists with account: the account
      And a blog "Donuts" exists with organization: organization "Food"
      And the following posts exist:
        | blog             | title       |
        | blog "Radiation" | No Danger   |
        | blog "Donuts"    | Forbidden!! |
     When I go to the page of the organization "Reactor"
     Then I should see a list of the following posts:
        | title       |
        | No Danger   |
      But I should not see "Forbidden"
