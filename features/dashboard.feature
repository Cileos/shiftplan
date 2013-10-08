Feature: Dashboard
  As an employee
  I want to see all my organizations with their plans on the dashboard page
  In order to be able to choose from one of them

  Background:
    Given mr burns, owner of the Springfield Nuclear Power Plant exists
      And a confirmed user "homer" exists with email: "homer@thesimpsons.de"
      And an employee "Homer" exists with first_name: "Homer", user: user "homer", account: the account
      And the employee "Homer" is a member of the organization
      And a plan "brennstäbe wechseln" exists with organization: the organization, name: "Brennstäbe wechseln"
      # week 49
      And today is 2012-12-04 06:00

  Scenario: Lists recent notifications
    Given a notification exists with employee: the employee "Homer"
      And I am signed in as the user "homer"
     When I go to the dashboard
     # full introductory_text of dummy notification
     Then I should see "You did something awesome"

    When I follow "Brennstäbe wechseln"
    Then I should be on the employees in week page of the plan for week: 49, cwyear: 2012

    When I go to the dashboard
     And I follow "Brennstäbe wechseln"
    Then I should be on the employees in week page of the plan "brennstäbe wechseln" for week: 49, cwyear: 2012

    When I go to the dashboard
     And I follow "Springfield Nuclear Power Plant - Sector 7-G"
    Then I should be on the page for the organization

  @javascript
  Scenario: List upcoming schedulings (just the next 7 days for now)
    Given a plan "Pumpen ölen" exists with name: "Pumpen ölen", organization: the organization
      # out-of-account plan for conflicts
    Given an account "Home" exists with name: "Home"
      And an organization "Garten" exists with name: "Garten", account: account "Home"
      And an employee "Daddy" exists with first_name: "Daddy", user: user "homer", account: account "Home"
      And the employee "Daddy" is a member of the organization "Garten"
      And a plan "Spazieren" exists with organization: organization "Garten", name: "Spazieren"

      And the employee "Homer" was scheduled in the plan "brennstäbe wechseln" as following:
        | week | cwday | quickie                         |
        | 49   | 2     | 9-17 Reaktor Putzen [RP]        |
        | 49   | 3     | 9-17 Links abbiegen [La]        |
        | 51   | 2     | 22-23 Verantwortung tragen [Vt] |
      And the employee "Homer" was scheduled in the plan "Pumpen ölen" as following:
        | week | cwday | quickie                         |
        | 49   | 3     | 10-18 Rechts abbiegen [Ra]      |
        | 50   | 3     | 10-18 Reaktor Fegen [RF]        |
      And the employee "Daddy" was scheduled in the plan "Spazieren" as following:
        | week | cwday | quickie                  |
        | 49   | 3     | 12-20 Kreise laufen [Kl] |
      And I am signed in as the user "homer"
     When I go to the dashboard
     Then I should see an agenda table with the following rows:
        | day | day-name | month-year | time    | team                 | organization | plan                |
        | 4   | Di       | Dez 2012   | 9 - 17  | Reaktor Putzen [RP]  | Sector 7-G   | Brennstäbe wechseln |
        | 5   | Mi !     | Dez 2012   | 9 - 17  | Links abbiegen [La]  | Sector 7-G   | Brennstäbe wechseln |
        | 5   | Mi !     | Dez 2012   | 10 - 18 | Rechts abbiegen [Ra] | Sector 7-G   | Pumpen ölen         |
        | 5   | Mi !     | Dez 2012   | 12 - 20 | Kreise laufen [Kl]   | Garten       | Spazieren           |
        | 12  | Mi       | Dez 2012   | 10 - 18 | Reaktor Fegen [RF]   | Sector 7-G   | Pumpen ölen         |
      But I should not see "22 - 23" within the schedulings module
      And I should not see "Verantwortung tragen" within the schedulings module

     When I follow "!" within the second table row within the agenda table
      And I wait for the modal box to appear
      Then I should see "9:00-17:00 Links abbiegen" within the left column within the modal box
      And I should see "10:00-18:00 Rechts abbiegen" within the right column within the modal box
      And I should see "12:00-20:00 Kreise laufen" within the right column within the modal box
     When I close the modal box

     When I follow "Reaktor Fegen [RF]" within the schedulings module
     Then I should be on the employees in week page of the plan "Pumpen ölen" for cwyear: 2012, week: 50
     Then I should be somewhere under the page of the plan "Pumpen ölen"

   Scenario: List recent news posts of company blogs of organizations I am a member in
    Given an organization "cooling towers" exists with name: "Cooling Towers", account: the account
      And a blog "cooling towers" exists with organization: organization "cooling towers"
      And the employee "Homer" is a member of the organization "cooling towers"
      And the following posts exist:
        | blog                   | title        | published_at  |
        | blog "sector 7g"       | No Danger    | 11.03.2011    |
        | blog "sector 7g"       | Level 7      | 11.04.2011    |
        | blog "cooling towers"  | Oops         | 26.04.1986    |
        | blog "cooling towers"  | Liquidators  | 01.12.1986    |
      And I am signed in as the user "homer"
     When I go to the dashboard
     Then I should see a list of the following posts:
        | title       |
        | Level 7     |
        | No Danger   |
        | Liquidators |
        | Oops        |
