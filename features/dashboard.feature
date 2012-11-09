Feature: Dashboard
  As an employee
  I want to see all my organizations with their plans on the dashboard page
  In order to be able to choose from one of them

  Background:
    Given a confirmed user "homer" exists with email: "homer@thesimpsons.de"
      And an account exists
      # week 49
      And today is 2012-12-04 06:00
      And the situation of an atomic power plant tschernobyl

  Scenario: Dashboard page with multiple organizations
    Given an organization "fukushima" exists with name: "AKW Fukushima GmbH", account: the account
      And the employee "Homer" is a member of the organization "fukushima"
      And a plan "reaktor putzen" exists with organization: organization "fukushima", name: "Reaktor putzen in Fukushima"


     And I am signed in as the user "homer"
    When I go to the dashboard

     And I should see "Organisationen" within the navigation
     And I should see "AKW Fukushima GmbH" within the organization dropdown list
     And I should see "AKW Tschernobyl GmbH" within the organization dropdown list

    When I go to the dashboard
     And I follow "AKW Fukushima GmbH"
     Then I should be on the page for the organization "fukushima"

  Scenario: Lists recent notifications
    Given a notification exists with employee: the employee "Homer"
      And I am signed in as the user "homer"
     When I go to the dashboard
     # full introductory_text of dummy notification
     Then I should see "You did something awesome"

  Scenario: List upcoming notifications (just the next 7 days for now)
    Given the employee "Homer" was scheduled in the plan as following:
        | week | cwday | quickie                         |
        | 49   | 2     | 9-17 Reaktor Putzen [RP]        |
        | 50   | 3     | 10-18 Reaktor Fegen [RF]        |
        | 51   | 2     | 22-23 Verantwortung tragen [Vt] |
      And I am signed in as the user "homer"
     When I go to the dashboard
     Then I should see an agenda table with the following rows:
       | day | day-name | month-year | time    | team                |
       | 4   | Di       | Dez 2012   | 9 - 17  | Reaktor Putzen [RP] |
       | 12  | Mi       | Dez 2012   | 10 - 18 | Reaktor Fegen [RF]  |
      But I should not see "22 - 23" within the schedulings module
      And I should not see "Verantwortung tragen" within the schedulings module

   Scenario: List recent news posts of company blogs
    Given an organization "fukushima" exists with name: "AKW Fukushima GmbH", account: the account
      And a blog "fukushima" exists with organization: organization "fukushima"
      And the employee "Homer" is a member of the organization "fukushima"
      And a blog "tschernobyl" exists with organization: organization "tschernobyl"
      And the following posts exist:
        | blog               | title       | published_at |
        | blog "fukushima"   | No Danger   | 11.03.2011   |
        | blog "fukushima"   | Level 7     | 11.04.2011   |
        | blog "tschernobyl" | Oops        | 26.04.1986   |
        | blog "tschernobyl" | Liquidators | 01.12.1986   |
      And I am signed in as the user "homer"
     When I go to the dashboard
     Then I should see a list of the following posts:
        | title       |
        | Level 7     |
        | No Danger   |
        | Liquidators |
        | Oops        |
