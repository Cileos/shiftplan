@javascript
Feature: Passive unavailability
  As a self planner
  I want to mark myself as busy in other accounts for the duration of my schedulings
  So that nobody accidently schedules me for the same time period

  But I cannot mark other's schedulings in the same way
  And I cannot inspect the value of foreign schedulings (defaulting to busy)

  Scenario: marking myself as busy
    Given mr burns, owner of the Springfield Nuclear Power Plant exists
      And an employee exists with first_name: "Homer", last_name: "Simpson", account: the account
      And the employee is member of the organization
      And a plan exists with organization: the organization
      And I am signed in as the user "mr burns"

     When I go to the page of the plan
      And I click on cell "Mo"/"Charles Burns"
     Then the "Beschäftigt" checkbox should be checked
      And the "Verfügbar" checkbox should not be checked

     When I choose "Verfügbar"
     When I select "Homer Simpson" from the "Mitarbeiter" single-select box
     Then I should not see a field labeled "Beschäftigt"
      And I should not see a field labeled "Verfügbar"

     When I select "Charles Burns" from the "Mitarbeiter" single-select box
     # back to default
     Then the "Beschäftigt" checkbox should be checked
      And the "Verfügbar" checkbox should not be checked

      And I press "Anlegen"
      And I wait for the modal box to disappear
     Then a scheduling should exist with represents_unavailability: true
