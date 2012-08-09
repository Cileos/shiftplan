Feature: Creating a plan
  In order to schedule work in my organization
  As a planner
  I want to create a plan

  @javascript
  Scenario: creating a weekly plan for the current organization
    Given today is 2012-02-01
      # monday
      And the situation of a nuclear reactor
      And I am on my dashboard

      When I follow "Reactor"
      Then I should be on the page for the organization "Reactor"
      When I choose "Alle Pläne" from the drop down "Pläne"
      And I follow "Hinzufügen"
      And I wait for the modal box to appear
      # duration of plan is fixed for now
      #And I choose "Woche"
      #And I press "Weiter"
      And I fill in "Name" with "Halloween im Atomkraftwerk"
      And I press "Anlegen"

     Then a plan should exist with organization: the organization, name: "Halloween im Atomkraftwerk"
      And I should be on the employees in week page for the plan for week: 5, year: 2012
      And the page should be titled "Halloween im Atomkraftwerk"
      And I should see a calendar titled "Halloween im Atomkraftwerk - KW 05 30.01.2012"
      And I should see the following calendar:
        | Mitarbeiter   | Mo | Di | Mi | Do | Fr | Sa | So |
        | Planner Burns |    |    |    |    |    |    |    |
        | Carl C        |    |    |    |    |    |    |    |
        | Lenny L       |    |    |    |    |    |    |    |
        | Homer S       |    |    |    |    |    |    |    |
