@javascript
Feature: All Day ness
  As a planner
  I want to create a Scheduling spanning the whole day
  In order to express that work will happen at sometime on that day

  Background:
    Given today is 2012-02-13
      And the situation of a nuclear reactor

  Scenario: create an all-day scheduling
     When I click on cell "Do"/"Homer S"
      And I wait for the modal box to appear
     Then the "Ganztägig" checkbox should not be checked

     # to make sure the time period will be enforced:
     When I schedule "8-10"
      And I check "Ganztägig"
     Then the field "Beginn" should be disabled
      And the field "Ende" should be disabled
      And I should see a field labeled "Tatsächliche Arbeitszeit"
      And I should see "Wird für die Wochenarbeitszeit und für Reports verwendet." within a hint

     When I uncheck "Ganztägig"
     Then the field "Beginn" should not be disabled
      And the field "Ende" should not be disabled
      And the "Beginn" field should contain "08:00"
      And the "Ende" field should contain "10:00"
      And I should not see a field labeled "Tatsächliche Arbeitszeit"

     When I check "Ganztägig"
     Then the field "Beginn" should be disabled
      And the field "Ende" should be disabled
      And I should see a field labeled "Tatsächliche Arbeitszeit"

     When I press "Anlegen"
      And I wait for the modal box to disappear
     Then I should see the following partial calendar:
        | Mitarbeiter   | Mo | Di | Mi | Do        | Fr | Sa | So |
        | Planner Burns |    |    |    |           |    |    |    |
        | Carl C        |    |    |    |           |    |    |    |
        | Lenny L       |    |    |    |           |    |    |    |
        | Homer S       |    |    |    | Ganztägig |    |    |    |
      And the employee "Homer S" should have a yellow hours/waz value of "0 / 40"

     When I click on the scheduling "Ganztägig"
      And I wait for the modal box to appear
      And I pick time 05:30 from "Tatsächliche Arbeitszeit"
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see the following partial calendar:
        | Mitarbeiter   | Mo | Di | Mi | Do                | Fr | Sa | So |
        | Planner Burns |    |    |    |                   |    |    |    |
        | Carl C        |    |    |    |                   |    |    |    |
        | Lenny L       |    |    |    |                   |    |    |    |
        | Homer S       |    |    |    | Ganztägig (05:30) |    |    |    |
      And the employee "Homer S" should have a yellow hours/waz value of "5½ / 40"


  Scenario: create an all-day shift
    Given a plan template exists with name: "Typische Woche", template_type: "weekbased", organization: the organization
      And a team exists with name: "A", organization: the organization
      And I am on the teams in week page for the plan template
     When I click on cell "Di"/"A(A)"
      And I wait for the modal box to appear
      And I schedule shift "9-17"

    Given I should not see a field labeled "Tatsächliche Arbeitszeit"
     When I check "Ganztägig"
     Then I should see a field labeled "Tatsächliche Arbeitszeit"
     When I uncheck "Ganztägig"
     Then I should not see a field labeled "Tatsächliche Arbeitszeit"
     When I check "Ganztägig"
      And I pick time 07:30 from "Tatsächliche Arbeitszeit"
      And I press "Anlegen"
      And I wait for the modal box to disappear
     Then a shift should exist with actual_length_in_hours: 7.5
