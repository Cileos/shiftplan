@javascript
Feature: All Day ness
  As a planner
  I want to create a Scheduling spanning the whole day
  In order to express that work will happen at sometime on that day

  Background:
    Given today is 2012-02-13
      And the situation of a nuclear reactor

  Scenario: create a all-day scheduling
     When I click on cell "Do"/"Homer S"
      And I wait for the modal box to appear
     Then the "Ganztägig" checkbox should not be checked

     # to make sure the time period will be enforced:
     When I schedule "8-10"
      And I check "Ganztägig"
     Then the field "Beginn" should be disabled
      And the field "Ende" should be disabled

     When I uncheck "Ganztägig"
     Then the field "Beginn" should not be disabled
      And the field "Ende" should not be disabled
      And the "Beginn" field should contain "08:00"
      And the "Ende" field should contain "10:00"

     When I check "Ganztägig"
     Then the field "Beginn" should be disabled
      And the field "Ende" should be disabled

     When I press "Anlegen"
      And I wait for the modal box to disappear
     Then I should see the following partial calendar:
        | Mitarbeiter   | Mo | Di | Mi | Do        | Fr | Sa | So |
        | Planner Burns |    |    |    |           |    |    |    |
        | Carl C        |    |    |    |           |    |    |    |
        | Lenny L       |    |    |    |           |    |    |    |
        | Homer S       |    |    |    | Ganztägig |    |    |    |
      And the employee "Homer S" should have a yellow hours/waz value of "0 / 40"
