Feature: Dashboard
  As an employee
  I want to see all my organizations with their plans on the dashboard page
  In order to be able to choose from one of them

  Background:
    Given a confirmed user "homer" exists with email: "homer@thesimpsons.de"
    And an account "main" exists with name: "Main"
      # week 49
      And today is 2012-12-04 06:00
      And the situation of an atomic power plant tschernobyl

  Scenario: Dashboard menu for owner with multiple accounts
    Given a confirmed user "bart" exists
      And an employee owner "owner bart" exists with first_name: "Bart", user: the confirmed user "bart", account: the account
      And an account "akw gmbh" exists with name: "Akw GmbH"
      And an organization "fukushima" exists with name: "Fukushima", account: the account "akw gmbh"
      And an employee "bart" exists with first_name: "Bart", user: the confirmed user "bart", account: the account "akw gmbh"
      And the employee "bart" is a member of the organization "fukushima"
      And I am signed in as the user "bart"
      And I go to the dashboard
     Then I should see "Accounts" within the navigation
      And I should see the following items in the account dropdown list:
        | Akw GmbH  |
        | Main      |

     When I follow "Main"
     Then I should be on the page of the account "main"
      And I should see the following table of organizations:
       | Name                  |
       | AKW Tschernobyl GmbH  |
     # bart is owner of account "main" so he can create new organizations
     When I follow "Hinzufügen"
     Then I should be on the new organization page for the account "main"
     # TODO fix navigation links
      And I fill in "Name" with "Another Organization"
      And I press "Anlegen"
     Then I should be on the page of the account "main"
      And I should see the following table of organizations:
       | Name                  |
       | AKW Tschernobyl GmbH  |
       | Another Organization  |

     When I go to the dashboard page
      And I follow "Akw GmbH"
     Then I should be on the page of the account "akw gmbh"
      And I should see the following table of organizations:
       | Name       |
       | Fukushima  |
       # bart is not owner of account "akw gmbh" so he cannot create new organizations
      But I should not see link "Hinzufügen"
     When I follow "Fukushima" within the organizations table
     Then I should be on the page for the organization "fukushima"

  Scenario: Dashboard page with multiple organizations
    Given an organization "fukushima" exists with name: "AKW Fukushima GmbH", account: the account
      And the employee "Homer" is a member of the organization "fukushima"
      And an account "private" exists with name: "Privat"
      And an organization "home" exists with name: "Home Homer", account: account "private"
      And an employee owner "homer at home" exists with user: confirmed user "homer", account: account "private"
      # VV this had created double entries in dropdown
      And the employee owner "homer at home" is a member of organization "home"
      And I am signed in as the user "homer"

     When I go to the dashboard
     Then I should see "Organisationen" within the navigation
     # currently ordered by creation date.
      And I should see the following items in the organization dropdown list:
        | Main - AKW Tschernobyl GmbH |
        | Main - AKW Fukushima GmbH   |
        | Privat - Home Homer         |

     When I follow "AKW Fukushima GmbH"
     Then I should be on the page for the organization "fukushima"

  Scenario: Lists recent notifications
    Given a notification exists with employee: the employee "Homer"
      And I am signed in as the user "homer"
     When I go to the dashboard
     # full introductory_text of dummy notification
     Then I should see "You did something awesome"

  Scenario: List upcoming schedulings (just the next 7 days for now)
    Given the employee "Homer" was scheduled in the plan as following:
        | week | cwday | quickie                         |
        | 49   | 2     | 9-17 Reaktor Putzen [RP]        |
        | 50   | 3     | 10-18 Reaktor Fegen [RF]        |
        | 51   | 2     | 22-23 Verantwortung tragen [Vt] |
      And I am signed in as the user "homer"
     When I go to the dashboard
     Then I should see an agenda table with the following rows:
       | day | day-name | month-year | time    | team                | plan                               |
       | 4   | Di       | Dez 2012   | 9 - 17  | Reaktor Putzen [RP] | Brennstäbe wechseln in Tschernobyl |
       | 12  | Mi       | Dez 2012   | 10 - 18 | Reaktor Fegen [RF]  | Brennstäbe wechseln in Tschernobyl |
      But I should not see "22 - 23" within the schedulings module
      And I should not see "Verantwortung tragen" within the schedulings module
     When I follow "Brennstäbe wechseln in Tschernobyl" within the schedulings module
     Then I should be somewhere under the page of the plan

   Scenario: List recent news posts of company blogs of organizations I am a member in
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
