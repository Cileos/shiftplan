@javascript
Feature: Personal Active Unavailabilities
  As an employee
  In order to tell my boss about the reason for staying away at a future day
  I want to maintain unavailability entries in a monthly calendar

  Background:
    Given today is 2012-12-21
      And an account "Work" exists with name: "Springfield NPP"
      And an organization exists with name: "Sector 7-G", account: the account
      And a confirmed user exists
      And an employee "Homer" exists with user: the confirmed user, first_name: "Homer", last_name: "S.", account: the account
      And the employee is a member of the organization
      And I am signed in as the confirmed user

  Scenario: Enter a sick day
    Given I am on the dashboard
     When I choose "Verfügbarkeit" from the session and settings menu item
      And I wait for Ember to boot
     Then I should be on the availability page
      And I should see the following calendar:
         | Mo | Di | Mi | Do | Fr | Sa | So |
         |    |    |    |    |    | 1  | 2  |
         | 3  | 4  | 5  | 6  | 7  | 8  | 9  |
         | 10 | 11 | 12 | 13 | 14 | 15 | 16 |
         | 17 | 18 | 19 | 20 | 21 | 22 | 23 |
         | 24 | 25 | 26 | 27 | 28 | 29 | 30 |
         | 31 |    |    |    |    |    |    |

     When I follow "21"
      And I wait for the modal box to appear
      # because I am an employee in only one account:
     Then I should not see "alle Accounts" within the modal box
     When I select "Krankheit" from "Grund"
      And I fill in "Beschreibung" with "My head hurts"
      And I uncheck "Ganztägig"
     #     And I select "Springfield NPP"
      And I press "Anlegen"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
         | Mo  | Di  | Mi  | Do  | Fr                                     | Sa  | So  |
         |     |     |     |     |                                        | 1   | 2   |
         | 3   | 4   | 5   | 6   | 7                                      | 8   | 9   |
         | 10  | 11  | 12  | 13  | 14                                     | 15  | 16  |
         | 17  | 18  | 19  | 20  | 21 6:00-18:00 Krankheit My head hurts  | 22  | 23  |
         | 24  | 25  | 26  | 27  | 28                                     | 29  | 30  |
         | 31  |     |     |     |                                        |     |     |
      And an unavailability should exist with reason: "illness", description: "My head hurts"
      And the confirmed user should be the unavailability's user

     When I follow "6:00-18:00"
      And I wait for the modal box to appear
      And I press "Löschen"
      And I wait for the modal box to disappear
      And I wait for ember to run
     Then I should see the following calendar:
         | Mo | Di | Mi | Do | Fr | Sa | So |
         |    |    |    |    |    | 1  | 2  |
         | 3  | 4  | 5  | 6  | 7  | 8  | 9  |
         | 10 | 11 | 12 | 13 | 14 | 15 | 16 |
         | 17 | 18 | 19 | 20 | 21 | 22 | 23 |
         | 24 | 25 | 26 | 27 | 28 | 29 | 30 |
         | 31 |    |    |    |    |    |    |

  Scenario: only show two of my bosses that I am sick, stay at home
    # mark as unavailbe for Work & Home, go to Moe's Bar.
    Given an account "Home" exists with name: "Home"
      And an organization "Family" exists with account: account "Home"
      And an employee "Daddy" exists with user: the confirmed user, account: account "Home"
      And the employee "Daddy" is a member of the organization "Family"

      And an account "Moe's" exists with name: "Moe's"
      And an organization "Bar" exists with account: account "Moe's"
      And an employee "Drunk Homer" exists with user: the confirmed user, account: account "Moe's"
      And the employee "Drunk Homer" is a member of the organization "Bar"

      And I go to the availability page
      And I wait for Ember to boot
     When I follow "21"
      And I wait for the modal box to appear
     Then the "alle Accounts" checkbox should be checked
      But I should not see a field labeled "Springfield NPP"
      But I should not see a field labeled "Home"
     When I uncheck "alle Accounts"
     Then the "Springfield NPP" checkbox should not be checked
      And the "Home" checkbox should not be checked
      And the "Moe's" checkbox should not be checked
     When I check "Springfield NPP"
      And I check "Home"
      And I select "Krankheit" from "Grund"
      And I uncheck "Ganztägig"
      And I press "Anlegen"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
         | Mo | Di | Mi | Do | Fr                                           | Sa | So |
         |    |    |    |    |                                              | 1  | 2  |
         | 3  | 4  | 5  | 6  | 7                                            | 8  | 9  |
         | 10 | 11 | 12 | 13 | 14                                           | 15 | 16 |
         | 17 | 18 | 19 | 20 | 21 6:00-18:00 6:00-18:00 Krankheit Krankheit | 22 | 23 |
         | 24 | 25 | 26 | 27 | 28                                           | 29 | 30 |
         | 31 |    |    |    |                                              |    |    |
      And an unavailability should exist with reason: "illness", user: confirmed user, employee: employee "Homer"
      And an unavailability should exist with reason: "illness", user: confirmed user, employee: employee "Daddy"
      But 0 unavailabilities should exist with employee: employee "Drunk Homer"

  Scenario: Changing a sick day to education
    Given an unavailability exists with reason: "illness", user: confirmed user, employee: employee "Homer", starts_at: "2012-12-21 6:00", ends_at: "2012-12-21 18:00"
      And I am on the dashboard
     When I choose "Verfügbarkeit" from the session and settings menu item
      And I wait for Ember to boot
      And I follow "6:00-18:00"
      And I wait for the modal box to appear
     Then the "Beginn" field should contain "06:00"
      And the "Ende" field should contain "18:00"
     When I schedule una "8-20"
      And I select "Weiterbildung" from "Grund"
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

  Scenario: Enter a all day sick day
    Given I am on the dashboard
     When I choose "Verfügbarkeit" from the session and settings menu item
      And I wait for Ember to boot

     When I follow "21"
      And I wait for the modal box to appear
     Then the "Ganztägig" checkbox should be checked
      And I should not see a field labeled "Beginn"
      And I should not see a field labeled "Ende"

     When I uncheck "Ganztägig"
     Then the "Beginn" field should contain "06:00"
      And the "Ende" field should contain "18:00"

     When I check "Ganztägig"
     Then I should not see a field labeled "Beginn"
      And I should not see a field labeled "Ende"
      And I select "Krankheit" from "Grund"

     When I press "Anlegen"
      And I wait for the modal box to disappear
     Then I should see the following calendar:
         | Mo | Di | Mi | Do | Fr                          | Sa | So |
         |    |    |    |    |                             | 1  | 2  |
         | 3  | 4  | 5  | 6  | 7                           | 8  | 9  |
         | 10 | 11 | 12 | 13 | 14                          | 15 | 16 |
         | 17 | 18 | 19 | 20 | 21 Ganztägig Krankheit      | 22 | 23 |
         | 24 | 25 | 26 | 27 | 28                          | 29 | 30 |
         | 31 |    |    |    |                             |    |    |
       And an unavailability should exist with all_day: true
