@wip
@javascript
Feature: Passive unavailability
  As a self planner
  I want to mark myself as busy in other accounts for the duration of my schedulings
  So that nobody accidently schedules me for the same time period

  But I cannot mark other's schedulings in the same way

  Scenario: marking myself as busy
    Given mr burns, owner of the Springfield Nuclear Power Plant exists
      And an employee exists with first_name: "Homer", last_name: "Simpson", account: the account
      And the employee is member of the organization
      And a plan exists with organization: the organization
      And I am signed in as the user "mr burns"

     When I go to the page of the plan
      And I click on cell "Mo"/"Charles Burns"
     Then the field "Beschäftigt" should not be disabled
      And the field "Verfügbar" should not be disabled

     When I select "Homer Simpson" from the "Mitarbeiter" single-select box
     Then the field "Beschäftigt" should be disabled
      And the field "Verfügbar" should be disabled

     When I select "Charles Burns" from the "Mitarbeiter" single-select box
     Then the field "Beschäftigt" should not be disabled
      And the field "Verfügbar" should not be disabled

     When I choose "Beschäftigt"
      And I press "Anlegen"
      And I wait for the modal box to disappear
     Then a scheduling should exist with represents_unavailability: true
