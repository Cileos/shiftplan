Feature: Create Duplicate Employee
  As a planner
  to avoid the creation of possible duplicate employees
  I want to see a warning

  Background:
    Given the situation of a just registered user

      # employee heinz meier 1 (heinz.meier@fukushima.de) of same organization(fukushima)
      And a confirmed user "heinz1" exists with email: "heinz.meier@fukushima.de"
      And an employee "heinz1" exists with first_name: "Heinz", last_name: "Meier", account: the account "tepco", user: the confirmed user "heinz1"
      And a membership exists with employee: the employee "heinz1", organization: the organization "fukushima"

      # employee heinz meier 2 without email of other organization(tschernobyl)
      And an organization "tschernobyl" exists with name: "Tschernobyl", account: the account "tepco"
      And an employee "heinz2" exists with first_name: "Heinz", last_name: "Meier", account: the account "tepco"
      And a membership exists with employee: the employee "heinz2", organization: the organization "tschernobyl"
      # heinz 1 is also member of organizaion tschernobyl
      And a membership exists with employee: the employee "heinz1", organization: the organization "tschernobyl"

     When I sign in as the confirmed user "mr. burns"
      And I am on the employees page for the organization "fukushima"

  @javascript
  Scenario: Creating duplicate employee Heinz Meier
    Given I follow "Hinzufügen"
      And I fill in "Vorname" with "Heinz"
      And I wait a bit
      # at least first name + beginning of last name must have been entered for a warnin
      # to be displayed
     Then I should not see "Folgende Mitarbeiter mit gleichem Namen existieren bereits:" within the duplication warning

     When I fill in "Nachname" with "Meier"
      And I wait a bit
     Then I should see "Folgende Mitarbeiter mit gleichem Namen existieren bereits:" within the duplication warning
      And I should see "Heinz Meier, E-Mail: heinz.meier@fukushima.de, Organisationen: Fukushima, Tschernobyl" within the duplication warning
      And I should see "Heinz Meier, E-Mail: keine, Organisationen: Tschernobyl" within the duplication warning
      And I should see "Sind Sie sicher, dass Sie den Mitarbeiter trotzdem anlegen möchten?" within the duplication warning

     When I fill in "Nachname" with "Meier-Schnarrenberger"
      And I wait a bit
     Then I should not see "Folgende Mitarbeiter mit gleichem Namen existieren bereits:" within the duplication warning
