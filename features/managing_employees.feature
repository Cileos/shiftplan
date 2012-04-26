Feature: Create Employees
  In order to assign my employees to their shift
  As a planner
  I want to manage employees

  Background:
    Given an organization exists with name: "Fukushima GmbH"
      # week 49
      And today is 2012-12-04
      And a confirmed user exists
      And a planner exists with first_name: "Homer", last_name: "Simpson", user: the confirmed user, organization: the organization
     When I sign in as the confirmed user
      And I follow "Fukushima GmbH"
      And I follow "Mitarbeiter"


  @javascript
  Scenario: Creating an employee
      And I follow "Hinzufügen"
      And I wait for the modal box to appear
     Then the "Wochenarbeitszeit" field should contain "40"
      And I fill in the following:
        | Vorname           | Carl    |
        | Nachname          | Carlson |
        | Wochenarbeitszeit | 30      |
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see flash info "Mitarbeiter erfolgreich angelegt."
      And I should be on the employees page for the organization
      And I should see "Carl Carlson"
      And I should see "30"

  @javascript
  Scenario: Creating an employee without a weekly working time
      And I follow "Hinzufügen"
      And I wait for the modal box to appear
      And I fill in the following:
        | Vorname           | Carl    |
        | Nachname          | Carlson |
        | Wochenarbeitszeit |         |
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see flash info "Mitarbeiter erfolgreich angelegt."

  @javascript
  Scenario: Editing an employee
      And I should be on the employees page for the organization
     Then I should not see "Carl Carlson"
     When I follow "Homer Simpson"
      And I wait for the modal box to appear
      And I fill in the following:
        | Vorname  | Carl    |
        | Nachname | Carlson |
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see flash info "Mitarbeiter erfolgreich geändert."
      And I should be on the employees page for the organization
      And I should see "Carl Carlson"
      But I should not see "Homer Simpson"

  @javascript
  Scenario: Editing an employee in the calendar view
    Given a plan exists with name: "Reaktor A", organization: the organization
      And I go to the page of the plan
     Then I should not see "Carl Carlson"
     # And I should not see "0 von 88"
     When I follow "Homer Simpson"
      And I wait for the modal box to appear
      And I fill in the following:
        | Vorname           | Carl    |
        | Nachname          | Carlson |
      # | Wochenarbeitszeit | 88      |
      And I press "Speichern"
      And I wait for the modal box to disappear
     Then I should see a flash info "Mitarbeiter erfolgreich geändert."
      And I should be on the page of the plan for week: 49
      And I should see "Carl Carlson"
      # And I should see "0 von 88"
      But I should not see "Homer Simpson"

  Scenario: Can only see employees of own organization
    Given another organization "Chefs" exists
      And an employee exists with organization: organization "Chefs", first_name: "Smithers"

      And I follow "Mitarbeiter"
     Then I should see "Homer Simpson"
      But I should not see "Smithers"

