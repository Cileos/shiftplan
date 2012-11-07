@javascript
Feature: Comment on Schedulings
  In order to fill all shifts and solve organizational problems
  As an employee
  I want to comment on schedulings

  Background:
    Given today is 2012-12-18
      And the situation of a nuclear reactor
      And the employee "Homer" was scheduled in the plan as following:
        | date       | quickie             |
        | 2012-12-21 | 7-23 Reaktor putzen |

  Scenario: planner writes the first comment
    Given I am on the page for the plan
     When I follow the comments link within cell "Fr"/"Homer S"
      And I comment "Excellent!"
     Then I should see "1" within the comment link within cell "Fr"/"Homer S"

  Scenario: planner writes the first comment using the keyboard
    Given I am on the page for the plan
     When I press arrow right 4 times
      And I press arrow down 2 times
      And I press key "c"
      And I comment "Excellent!"
     Then I should see "1" within the comment link within cell "Fr"/"Homer S"

  @todo
  @wip
  Scenario: employee answers
    Given a scheduling should exist
      And employee "Burns" has commented the scheduling with "Excellent!"
      And I sign out
      And I sign in as the user "Homer"
     When I go to the page for the plan
     Then I should see "1" within the comment link within cell "Fr"/"Homer S"
     When I follow "1" within cell "Fr"/"Homer S"
      And I wait for the modal box to appear
     Then the "Kommentar" field should be empty
      And I should see "Excellent!" within comments within the modal box
      And I should see "Planner Burns" within comments within the modal box
     When I follow "Antworten"
      And I fill in "Kommentar" with "D'ooh!"
      And I press "Antworten"
      And I wait for the spinner to disappear
     Then the "Kommentar" field should be empty
      And I should see "D'ooh!" within replies within comments within the modal box
      And I should see "Sie haben am 18.12.2012 um 00:00 Uhr geschrieben:" within comments within the modal box
      But I should not see "Antworten" within "button"
     When I close the modal box
     Then I should see "2" within the comment link within cell "Fr"/"Homer S"
      And I sign out

      # notification for all planners
      And "burns@shiftplan.local" should receive an email with subject "Homer S hat auf Ihren Kommentar zu einer Schicht geantwortet"
     When I open the email with subject "Homer S hat auf Ihren Kommentar zu einer Schicht geantwortet"
     Then I should see "Homer S hat auf Ihren Kommentar zu einer Schicht von Homer S am Freitag, den 21.12.2012 (7-23 Reaktor putzen [Rp]) geantwortet:" in the email body
      And I should see "D'ooh!" in the email body
     When I follow the first link in the email
     Then I fill in "E-Mail" with "burns@shiftplan.local"
      And I fill in "Passwort" with "secret"
      And I press "Einloggen"
     Then I should be on the employees in week page of the plan for week: 51, year: 2012
      And I should see "7-23 Rp"

