Feature: Creating a plan
  In order to schedule work in my organization
  As a planer
  I want to create a plan

  Scenario: creating a plan for the current plan
    Given a planer exists
      And an organization exists with planer: the planer
      And the organization has the following employees:
        | first_name |
        | Homer      |
        | Larry      |
        | Karl       |
      And today is 2011-10-01
      And I am signed in as the planer

     When I follow "neuer Plan"
      And I choose "ganzer Monat"
      And I press "Weiter"
      And I choose "Oktober 2011"
      And I fill in "Name" with "Halloween im Atomkraftwerk"
      And I press "Anlegen"

     Then a plan should exist
      And I should be on the page for the plan
      And the page should be titled "Halloween im Atomkraftwerk"
      And I should see the following calendar:
        | Mitarbeiter | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 | 25 | 26 | 27 | 28 | 29 | 30 | 31 |
        | Homer       |   |   |   |   |   |   |   |   |   |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
        | Larry       |   |   |   |   |   |   |   |   |   |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
        | Karl        |   |   |   |   |   |   |   |   |   |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
