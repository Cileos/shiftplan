@javascript
Feature: Passive unavailability
  As a self planner
  I want to mark myself as busy in other accounts for the duration of my schedulings
  So that nobody accidently schedules me for the same time period

  But I cannot mark other's schedulings in the same way
  And I cannot inspect the value of foreign schedulings (defaulting to busy)


  Background:
    Given mr burns, owner of the Springfield Nuclear Power Plant exists
      And an employee "Homer" exists with first_name: "Homer", last_name: "Simpson", account: the account
      And the employee is member of the organization
      And a plan exists with organization: the organization
      And I am signed in as the user "mr burns"


  Scenario: marking myself as busy
     When I go to the page of the plan
      And I click on cell "Mo"/"Charles Burns"
      And I wait for the modal box to appear
     Then the "Beschäftigt" checkbox should be checked
      And the "Verfügbar" checkbox should not be checked

     When I choose "Verfügbar"
     When I select "Homer Simpson" from the "Mitarbeiter" single-select box
     Then I should not see a field labeled "Beschäftigt"
      And I should not see a field labeled "Verfügbar"

     When I select "Charles Burns" from the "Mitarbeiter" single-select box
     # not back to default
     Then the "Verfügbar" checkbox should be checked
      And the "Beschäftigt" checkbox should not be checked

     When I choose "Beschäftigt"
      And I press "Anlegen"
      And I wait for the modal box to disappear
     Then a scheduling should exist with represents_unavailability: true


  Scenario: cannot determine busy state of scheduling of a self-planner
    Given the employee "Homer" was scheduled in the plan as following:
        | year | week | cwday | quickie | represents_unavailability |
        | 2012 | 6    | 1     | 9-17    | false                     |
      And I am on the employees in week page for the plan for cwyear: 2012, week: 5
     When I click on cell "Mo"/"Homer Simpson"
      And I wait for the modal box to appear

     Then I should not see a field labeled "Beschäftigt"
      And I should not see a field labeled "Verfügbar"

     When I select "Charles Burns" from the "Mitarbeiter" single-select box
     # back to default
     Then the "Beschäftigt" checkbox should be checked
      And the "Verfügbar" checkbox should not be checked
